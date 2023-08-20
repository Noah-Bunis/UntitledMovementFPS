extends Spatial

onready var anim_player = $AnimationPlayer
func unload():
	queue_free()
func _ready():
	anim_player.play("Default")
