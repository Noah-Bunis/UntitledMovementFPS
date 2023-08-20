extends RigidBody
onready var Player = $"/root/Global".player
func _ready():
	add_to_group("Entity")
	add_to_group("Gramophone")
	


func knockback(direction):
	add_central_force(direction)

	
func _process(_delta):
		if get_translation().y <-20 and Player.dying == false:
			Player.dying = true
			var dialog = Dialogic.start("Gramodeath")
			add_child(dialog)
			yield(get_tree().create_timer(5), "timeout")
			Player.death()
			Player.dying = false
			
