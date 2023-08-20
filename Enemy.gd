extends KinematicBody
var health = 10
onready var anim_player = $AnimationPlayer
var dying = false

func _ready():
	anim_player.play("RESET")
	add_to_group("Enemy")
	add_to_group("Gives_Boost")

func death_sequence():
	dying = true
	anim_player.play("Death")
	yield(get_tree().create_timer(1), "timeout")
	queue_free()
	
func give_boost():
	$"/root/Global".player.boost_count +=1
	$"/root/Global".player.HUD.boosts +=1
func _process(delta):
	if health <= 0:
		death_sequence()
