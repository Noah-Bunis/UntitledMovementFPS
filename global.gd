extends Node
var player
var equipped = ""
var level = 0
var sens = 0.1
var cheats = false
var weapon_tutorial = true
var DefaultBinds = ["W","S","A","D","Space","Shift","Left Click","F","G","N","Escape"]
func _ready():
	pass
func register_player(in_player):
	player = in_player
func register_item(item):
	equipped = item
func mouse_restore():
	if get_tree().get_current_scene().get_name() == "Main Menu":
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
func _process(delta):
	mouse_restore()
