extends Spatial



# Called when the node enters the scene tree for the first time.
func _ready():
	$"/root/Global".player.equipped = ""
	var dialog = Dialogic.start("0-0 Dialogue")
	add_child(dialog)
