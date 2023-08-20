extends StaticBody

const GOLDEN_ANGLE = PI * (3-sqrt(5))

export var base_force_ray = 0.45
export var radius := 20
export var num_points := 1024
var rays := []

func _ready():
	_create_rays()
	$AnimationPlayer.play("Explode")
func _create_rays() -> void:
	var points = _get_points()
	for point in points:
		var ray = RayCast.new()
		add_child(ray)
		ray.cast_to = point
		ray.enabled = false
		ray.exclude_parent = true
		rays.append(ray)

func _get_points() -> Array:
	var points := []
	
	for point in num_points:
		var y: float = 1.0 - (point/ (num_points - 1.0)) * 2.0
		var r: float = sqrt(1-y*y)
		
		var angle_increment: float = GOLDEN_ANGLE * point
		
		var x: float = cos(angle_increment) * r
		var z: float = sin(angle_increment) * r
		
		points.append(Vector3(x,y,z) * radius)
	return points

func _get_explosion_ray_data() -> Array:
	var colliding_rays:= []
	for ray in rays:
		ray.enabled = true
		ray.force_raycast_update()
		if ray.is_colliding():
			colliding_rays.append(ray)
	return colliding_rays

func _explode():
	var explosion_rays = _get_explosion_ray_data()
	for ray in explosion_rays:
		var collider = ray.get_collider()
		
		if collider.has_method("take_explosion"):
			collider.take_explosion(base_force_ray,ray)
		if collider.has_method("knockback"):
			collider.knockback(ray.get_cast_to())
		if collider.is_in_group("Gives_Boost"):
			if collider.dying == false:
				collider.death_sequence()
		
	
	


