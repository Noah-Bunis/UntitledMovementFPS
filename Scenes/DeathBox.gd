extends Spatial
onready var Player = $"/root/Global".player

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


func _on_Area_body_entered(body):
	if body == Player:
		Player.death()
	elif body.is_in_group("Gramophone"):
		Player.death()
