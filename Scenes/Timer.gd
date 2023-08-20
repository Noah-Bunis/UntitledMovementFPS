extends Label

var time = 0
var timer_on = false

func timer_start():
	timer_on = true
func timer_stop():
	timer_on = false
func timer_reset():
	time = 0
	
func _process(delta):
	if timer_on:
		time += delta
	var milsecs = fmod(time,1) *1000
	var secs = fmod(time,60)
	var mins = fmod(time, 60*60) / 60
	
	var time_passed = "%02d : %02d : %03d" % [mins, secs, milsecs]
	text = time_passed
