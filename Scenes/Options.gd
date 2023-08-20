extends Control
export var MainMenu : PackedScene
export var Keybinds : PackedScene
onready var CheckBox = $"MarginContainer/GridContainer/HBoxContainer/Cheats/CheckBox"
func _ready():
	add_to_group("Menu")
	$MarginContainer/GridContainer/Sens/LineEdit.text = str($"/root/Global".sens)
	if $"/root/Global".cheats == true:
		CheckBox.set_pressed_no_signal(true)
	else:
		CheckBox.set_pressed_no_signal(false)


func _on_Back_button_up():
	get_tree().change_scene(MainMenu.resource_path)

func _on_Keybinds_button_up():
	get_tree().change_scene("res://Scenes/Keybinds.tscn")


func _on_LineEdit_text_entered(new_text):
	$MarginContainer/GridContainer/Sens/LineEdit.text = new_text
	$"/root/Global".sens = float(new_text)


func _on_CheckBox_toggled(button_pressed):
	if button_pressed == true:
		$"/root/Global".cheats = true
	else:
		$"/root/Global".cheats = false



