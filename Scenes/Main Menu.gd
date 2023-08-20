extends Node2D
onready var Player = $"/root/Global".player
onready var HUD = $"/root/Hud"
onready var LoadScreen = $"/root/Hud/LoadScreen"
onready var timer = $"/root/Hud/Display/Timer"
export var mainGameScene : PackedScene



func _on_New_Game_button_up():
	timer.time = 0
	HUD.load_scene(mainGameScene.resource_path)
	$"/root/Global".level = 0
	timer.timer_reset()
	timer.timer_start()
	HUD.Display_Values.visible = true
	


func _on_Quit_button_up():
	get_tree().quit()

func _ready():
	add_to_group("Menu")
	timer.timer_stop()
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	


func _on_Options_button_up():
	get_tree().change_scene("res://Scenes/Options.tscn")


func _on_Credits_button_up():
	get_tree().change_scene("res://Scenes/Credits.tscn")
