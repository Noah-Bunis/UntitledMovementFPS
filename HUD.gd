extends Node2D
onready var timer = $"/root/Hud/Display/Timer"
onready var Player = $"/root/Global".player
onready var Display_Values = $"Display/Data Values"
onready var Display = $Display
onready var LoadScreen = $LoadScreen
var boosts = 0
var equipped = ""
var level = 0
var speed = 0
func _ready():
	LoadScreen.visible = false
func toggle_LoadScreen():
	if LoadScreen.visible == true:
		LoadScreen.visible = false
	else:
		LoadScreen.visible = true
func _process(_delta):
	if get_tree().get_current_scene().is_in_group("Menu"):
		Display_Values.visible = false
	else:
		Display_Values.visible = true
	Display_Values.set_text(equipped +'\n'+ "Boosts: "+str(boosts)+"\n Speed: "+str(speed))
	if $"/root/Global".cheats == true:
		Display_Values.set_text('Cheats Enabled' +'\n'+ "Boosts: "+str(boosts)+"\n Speed: "+str(speed))
func load_scene(next_scene):
	timer.timer_stop()
	toggle_LoadScreen()
	yield(get_tree().create_timer(0.2),"timeout")
	get_tree().change_scene(next_scene)
	toggle_LoadScreen()
	timer.timer_start()
	
