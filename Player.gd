extends KinematicBody
const DEFAULT_SPEED = 12
var speed = 12
const ACCEL_DEFAULT = 12
const ACCEL_AIR = 0.7
const DEFAULT_JUMP = 9
onready var accel = ACCEL_DEFAULT
var cam_accel = 40
var gravity = 20
var jump = 9
var wall_jumps = 1
var mouse_sense = 0.1
var snap
var f_input = 0
var h_input = 0
var direction = Vector3()
var velocity = Vector3()
var gravity_vec = Vector3()
var movement = Vector3()
var boost_count = 0
var wall_target
onready var head = $Head
onready var camera = $Head/Camera
var looking_direction = "Forward"
var dying = false

var target_fov
#SLIDING VARS
const DEFAULT_SLIDE_SPEED = 35
var fall_distance = 0
var slide_speed = 0
var sliding = false
var falling = false
var dashing = false
var wall_running = false
var wall_kick = false
var wall_normal
var crushed = false
onready var slide_check = $Slide_Check

#SHOOTING VARS
var target
var damage = 10
var bullet_force = 45
onready var anim_player = $AnimationPlayer
onready var hand_anim = $HandAnimation
onready var cam_anim = $CameraAnimation
onready var raycast = $Head/Camera/RayCast
onready var pickup = $Head/Camera/Reach
onready var left_wall = $Left_Wall
onready var right_wall = $Right_Wall
onready var b_decal = preload("res://Scenes/BulletDecal.tscn")
onready var HUD = $"/root/Hud"
onready var HUD_Animation = $"/root/Hud/HUD Effects"
onready var timer = $"/root/Hud/Display/Timer"
#INVENTORY VARS
var e_index = 0
var equipments = ["","Revolver"]
onready var Revolver = $Head/Camera/Hand/Revolver
onready var Revolver_SFX = $"Revolver SFX"
var equipped = ""
var glass_count = 5

func hide_all():
	for i in $Head/Camera/Hand.get_children():
		i.visible = false

func display_weapon():
	if equipped == "":
		hide_all()
	elif equipped == "Revolver":
		hide_all()
		Revolver.visible = true
		for i in Revolver.get_children():
			i.visible = true
		
func _ready():
	#hides the cursor
	mouse_sense = $"/root/Global".sens
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	add_to_group("Player")
	$"/root/Global".register_player(self)
	Hud.boosts = boost_count
	#Preload
	var BulletPreload = preload("res://Assets/materials/Bullet.tres")
	var FlashPreload = preload("res://Assets/materials/Flash.tres")
	var GlassPreload = preload("res://Assets/materials/Glass.tres")
	var ShellPreload = preload("res://Assets/materials/Shell.tres")
	var materials = [BulletPreload,FlashPreload,GlassPreload,ShellPreload]
	for material in materials:
		var particles_instance = Particles.new()
		particles_instance.set_process_material(material)
		particles_instance.set_one_shot(true)
		particles_instance.set_emitting(true)
		self.add_child(particles_instance)
	
	equipped = $"/root/Global".equipped
	
func _input(event):
	#get mouse input for camera rotation
	if event is InputEventMouseMotion:
		rotate_y(deg2rad(-event.relative.x * mouse_sense))
		head.rotate_x(deg2rad(-event.relative.y * mouse_sense))
		head.rotation.x = clamp(head.rotation.x, deg2rad(-90), deg2rad(90))

func fire_animation():
	if Input.is_action_just_pressed("fire"):
		if equipped == "Revolver" and hand_anim.get_current_animation() != "Fire_Revolver":
			Revolver_SFX.play()
			hand_anim.play("Fire_Revolver")
			
func fire():
	if raycast.is_colliding():
		#Bullet Hole
		var b = b_decal.instance()
		get_tree().root.add_child(b)
		b.global_transform.origin = raycast.get_collision_point()
		b.look_at(raycast.get_collision_point() + raycast.get_collision_normal(), Vector3.UP)
		target = raycast.get_collider()
		if target.is_in_group("Entity"):
			target.knockback(-raycast.get_collision_normal()*bullet_force)
		if target.is_in_group("Enemy"):
			hitstop(0.05, 0.2)
			target.health -= damage

			
func pickup():
	if pickup.is_colliding():
		var target = pickup.get_collider()
		if target.is_in_group("Revolver"):
			equipped = "Revolver"
			$"/root/Global".register_item(equipped)
			target.queue_free()
		elif target.is_in_group("Gramophone"):
			target.queue_free()
		elif target.is_in_group("NoWallRun"):
			wall_target = target

func hitstop(timeScale, duration):
	Engine.time_scale = timeScale
	yield(get_tree().create_timer(duration * timeScale), "timeout")
	Engine.time_scale = 1.0

func camera_fov():
	if wall_running:
		target_fov = 86
	elif sliding:
		target_fov = 81
	else:
		target_fov = 80
	
	camera.interpolateFOV(target_fov, 1)
	
func death():
	timer.timer_stop()
	dying = true
	anim_player.play("Death")
	hitstop(0.1,0.5)
	yield(get_tree().create_timer(0.2), "timeout")
	get_tree().reload_current_scene()
	boost_count = 0
	HUD.boosts = boost_count
	dying = false
	timer.timer_start()

			
func _process(delta):
	#camera physics interpolation to reduce physics jitter on high refresh-rate monitors
	if Engine.get_frames_per_second() > Engine.iterations_per_second:
		camera.set_as_toplevel(true)
		camera.global_transform.origin = camera.global_transform.origin.linear_interpolate(head.global_transform.origin, cam_accel * delta)
		camera.rotation.y = rotation.y
		camera.rotation.x = head.rotation.x
	else:
		camera.set_as_toplevel(false)
		camera.global_transform = head.global_transform
		
	if Input.is_action_just_pressed("slide") and is_on_floor():
		slide()
	if Input.is_action_just_pressed("slide") and not is_on_floor():
		slide_buffer()
	if Input.is_action_just_released("slide"):
		if crushed:
			pass
		else:
			anim_player.queue("RESET")
			cam_anim.play("RESET")
			sliding = false
			speed = DEFAULT_SPEED
			HUD_Animation.play("RESET")
	
	HUD.equipped = equipped
#SPECIAL MOVEMENT FUNCTIONS

func wall_run():
	if is_on_wall() and not slide_check.is_colliding() and Input.is_action_pressed("slide"):
		if dashing and wall_kick == false:
			gravity_vec = Vector3.ZERO
			HUD_Animation.play("Sliding")
			wall_running = true
			if Input.is_action_just_pressed("jump") and wall_jumps > 0 and not is_on_ceiling():
				wall_jump()
	else:
		wall_running = false

func cheats():
	if $"/root/Global".cheats == true:
		if Input.is_action_just_pressed("test_gun"):
			e_index +=1
			equipped = equipments[e_index%3]
			$"/root/Global".register_item(equipped)
func slide():
	anim_player.play("Slide")
	HUD_Animation.seek(0,true)
	HUD_Animation.queue("Sliding")
	speed = lerp(speed, speed+5, 0.1)
	if not sliding:
		if slide_check.is_colliding() or get_floor_angle() < 0.2:
			slide_speed += fall_distance/10
		else:
			slide_speed = DEFAULT_SLIDE_SPEED
	sliding = true
	if slide_check.is_colliding():
		slide_speed += get_floor_angle() / 10
	else:
		slide_speed -= (get_floor_angle() / 10) + 0.03
	if slide_speed < 1:
		slide_speed = 0
		sliding = false
		speed = DEFAULT_SPEED
	speed = slide_speed
	slide_speed = DEFAULT_SLIDE_SPEED

func slide_buffer():
	anim_player.queue("Slide")
	if slide_check.is_colliding():
		slide()
		
func dash_jump():
	HUD_Animation.seek(0,true)
	HUD_Animation.play("Dash Jump")
	hitstop(0.05,0.2)
	boost_count -= 1
	HUD.boosts -= 1
	if not dashing:
		jump +=10
	jump += 6
	speed += 16
	
func wall_jump():
	wall_kick = true
	wall_jumps -=1
	snap = Vector3.ZERO
	if dashing:
		gravity_vec = Vector3.UP * jump*1.2
	else:
		gravity_vec = Vector3.UP * jump *5
	jump = DEFAULT_JUMP
	if boost_count > 0:
		dash_jump()
	wall_normal = get_slide_collision(0)
	direction = wall_normal.normal * speed/2
	yield(get_tree().create_timer(0.1), "timeout")
	wall_kick = false
	
func _physics_process(delta):
	#get keyboard input
	var h_rot = global_transform.basis.get_euler().y
	f_input = Input.get_action_strength("move_backward") - Input.get_action_strength("move_forward")
	h_input = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	if wall_kick == true:
		pass
	else:
		direction = Vector3(h_input, 0, f_input).rotated(Vector3.UP, h_rot).normalized()

	
	if Input.is_action_just_pressed('escape'):
		HUD.load_scene("res://Scenes/Main Menu.tscn")
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		timer.timer_reset()
		$"/root/Global".level = 0
	if Input.is_action_just_pressed("reset"):
		death()
	
	pickup()
	display_weapon()
	fire_animation()
	wall_run()
	cheats()
	camera_fov()
	
	HUD.speed = int((abs(movement.x) + abs(movement.y) + abs(movement.z))/3)
	
	#jumping and gravity
	if is_on_ceiling() and is_on_floor():
		crushed = true
		slide()
	if not is_on_ceiling() and crushed:
		crushed = false
		if not Input.is_action_pressed("slide"):
			Input.action_release("slide")
	if is_on_floor():
		if HUD_Animation.current_animation == "Dash Jump":
			if sliding:
				HUD_Animation.play("Sliding")
			else:
				HUD_Animation.play("RESET")
		snap = -get_floor_normal()
		accel = ACCEL_DEFAULT
		gravity_vec = Vector3.ZERO
		falling = false
		wall_jumps = 1
		cam_anim.queue("RESET")
	else:
		snap = Vector3.ZERO
		accel = ACCEL_AIR
		gravity_vec += Vector3.DOWN * gravity * delta
		falling = true
	if sliding:
		accel = 0.5

	if Input.is_action_just_pressed("jump") and is_on_floor() and not is_on_ceiling():
		if sliding:
			slide_speed += 1
			if boost_count > 0:
				dash_jump()
		snap = Vector3.ZERO
		gravity_vec = Vector3.UP * jump
		jump = DEFAULT_JUMP


	if falling and gravity_vec.y < -40:
		gravity_vec.y = -40
	#sliding
	if falling and is_on_floor() and sliding:
		slide_speed += fall_distance /10
	fall_distance = -gravity_vec.y

	if get_translation().y <-20 and not dying:
		death()
	#make it move
	velocity = velocity.linear_interpolate(direction * speed, accel * delta)
	movement = velocity + gravity_vec
	if abs(movement.x) > DEFAULT_SPEED or abs(movement.z) > DEFAULT_SPEED:
		dashing = true
	else:
		dashing = false
	
	move_and_slide_with_snap(movement, snap, Vector3.UP)
	
func _on_Left_Wall_body_entered(body):
	yield(get_tree().create_timer(0.1), "timeout")
	wall_target = body
	if wall_running:
		wall_jumps =1
		cam_anim.play("tilt_l")
		wall_kick = false
func _on_Right_Wall_body_entered(body):
	wall_target = body
	yield(get_tree().create_timer(0.1), "timeout")
	if wall_running:
		wall_jumps =1
		cam_anim.play("tilt_r")
		wall_kick = false

