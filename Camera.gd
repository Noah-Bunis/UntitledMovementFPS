extends Camera

var target_fov: float
var interpolation_duration: float = 1.0  # Time in seconds to complete the interpolation
var elapsed_time: float = 0.0

func _process(delta: float) -> void:
	if elapsed_time < interpolation_duration:
		elapsed_time += delta
		var t = elapsed_time / interpolation_duration
		t = clamp(t, 0.0, 1.0)
		
		fov = lerp(fov, target_fov, t)
	else:
		fov = target_fov
		elapsed_time = interpolation_duration

func interpolateFOV(new_target_fov: float, duration: float = 1.0) -> void:
	target_fov = new_target_fov
	interpolation_duration = duration
	elapsed_time = 0.0

