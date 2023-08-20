extends Control
export var MainMenu : PackedScene
func _ready():
	add_to_group("Menu")
	
func _on_Back_button_up():
	get_tree().change_scene(MainMenu.resource_path)
