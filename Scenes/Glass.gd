extends KinematicBody
var health = 10
onready var anim_player = $AnimationPlayer
onready var audio_player = $AudioStreamPlayer

func _ready():
	add_to_group("NoWallRun")
	add_to_group("Enemy")
	add_to_group("Glass")
	
func _process(delta):
	if health <= 0:
		health +=1
		death_sequence()
		
func death_sequence():
	audio_player.play()
	anim_player.play("Death")
	yield(get_tree().create_timer(1), "timeout")
	queue_free()
