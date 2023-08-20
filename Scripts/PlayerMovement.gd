extends "res://Player.gd"
func _ready():
	#hides the cursor
	mouse_sense = $"/root/Global".sens
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
func _input(event):
	#get mouse input for camera rotation
	if event is InputEventMouseMotion:
		rotate_y(deg2rad(-event.relative.x * mouse_sense))
		head.rotate_x(deg2rad(-event.relative.y * mouse_sense))
		head.rotation.x = clamp(head.rotation.x, deg2rad(-90), deg2rad(90))
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

func take_explosion(force,ray):
	explosion_hit = true
	snap = Vector3.ZERO
	direction.y = ray.get_cast_to().y * force
	yield(get_tree().create_timer(0.2), "timeout")
	explosion_hit = false
	#get keyboard input
	var h_rot = global_transform.basis.get_euler().y
	f_input = Input.get_action_strength("move_backward") - Input.get_action_strength("move_forward")
	h_input = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	if wall_kick == true:
		pass
	elif explosion_hit == true:
		pass
	else:
		direction = Vector3(h_input, 0, f_input).rotated(Vector3.UP, h_rot).normalized()
	
	pickup()
	display_weapon()
	fire_animation()
	wall_run()
	cheats()
	
	
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
		snap = Vector3.DOWN
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

