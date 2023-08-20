extends KinematicBody

onready var Player = $"/root/Global".player
func _ready():
	add_to_group("Revolver")
	
