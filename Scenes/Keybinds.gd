extends Control
export var Options : PackedScene
#Dropdown Menus
onready var Dropdown0 = $"VBoxContainer/VBoxContainer/BindRow 0/Dropdown 0"
onready var Dropdown1 = $"VBoxContainer/VBoxContainer/BindRow 1/Dropdown 1"
onready var Dropdown2 = $"VBoxContainer/VBoxContainer/BindRow 2/Dropdown 2"
onready var Dropdown3 = $"VBoxContainer/VBoxContainer/BindRow 3/Dropdown 3"
onready var Dropdown4 = $"VBoxContainer/VBoxContainer/BindRow 4/Dropdown 4"
onready var Dropdown5 = $"VBoxContainer/VBoxContainer/BindRow 5/Dropdown 5"
onready var Dropdown6 = $"VBoxContainer/VBoxContainer/BindRow 6/Dropdown 6"
onready var Dropdown7 = $"VBoxContainer/VBoxContainer/BindRow 7/Dropdown 7"
onready var Dropdown8 = $"VBoxContainer/VBoxContainer/BindRow 8/Dropdown 8"
onready var Dropdown9 = $"VBoxContainer/VBoxContainer/BindRow 9/Dropdown 9"
onready var Dropdown10 = $"VBoxContainer/VBoxContainer/BindRow 10/Dropdown 10"
onready var Dropdown = [Dropdown0,Dropdown1,Dropdown2,Dropdown3,Dropdown4,Dropdown5,Dropdown6,
Dropdown7,Dropdown8,Dropdown9,Dropdown10]
#Keybind Vars
onready var DefaultBinds = $"/root/Global".DefaultBinds
var AvailableKeys = "Left Click,Right Click,Space,Shift,Control,A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,0,1,2,3,4,5,6,7,8,9,!,$,%,&,(,),*,+,-,.,:,;,<,=,>,?,@,[,],^,_,`,{,},~".split(',')
var KeyNames = [BUTTON_LEFT,BUTTON_RIGHT,KEY_SPACE,KEY_SHIFT,KEY_CONTROL,KEY_A,KEY_B,KEY_C,KEY_D,KEY_E,KEY_F,KEY_G,KEY_H,KEY_I,KEY_J,KEY_K,KEY_L,KEY_M,KEY_N,KEY_O,KEY_P,KEY_Q,KEY_R,KEY_S,KEY_T,KEY_U,KEY_V,KEY_W,KEY_X,KEY_Y,KEY_Z,KEY_0,KEY_1,KEY_2,KEY_3,KEY_4,KEY_5,KEY_6,KEY_7,KEY_8,KEY_9,KEY_EXCLAM,KEY_DOLLAR,KEY_PERCENT,KEY_AMPERSAND,KEY_PARENLEFT,KEY_PARENRIGHT,KEY_ASTERISK,KEY_PLUS,KEY_MINUS,KEY_PERIOD,KEY_COLON,KEY_SEMICOLON,KEY_LESS,KEY_EQUAL,KEY_GREATER,KEY_QUESTION,KEY_AT,KEY_BRACKETLEFT,KEY_BRACKETRIGHT,KEY_6,KEY_UNDERSCORE,KEY_ASCIITILDE,KEY_BRACELEFT,KEY_BRACERIGHT,KEY_ASCIITILDE]
func _ready():
	add_to_group("Menu")
	add_items()
func _on_Back_button_up():
	get_tree().change_scene(Options.resource_path)
	
func add_items():
	for i in range(len(Dropdown)):
		Dropdown[i].add_item(DefaultBinds[i])
		for e in range(len(AvailableKeys)):
			Dropdown[i].add_item(AvailableKeys[e])
			
#BINDING NEW KEY FUNCTIONS
func _on_Dropdown_0_item_selected(index):
	$"/root/Global".DefaultBinds[0] = AvailableKeys[index-1]
	
	for i in InputMap.get_action_list("move_forward"):
		InputMap.action_erase_event("move_forward", i)
	if AvailableKeys[index-1] == "Left Click":
		var new_event = InputEventMouseButton.new()
		new_event.button_index = BUTTON_LEFT
		InputMap.action_add_event("move_forward", new_event)
	elif AvailableKeys[index-1] == "Right Click":
		var new_event = InputEventMouseButton.new()
		new_event.button_index = BUTTON_RIGHT
		InputMap.action_add_event("move_forward", new_event)
	else:
		var new_event = InputEventKey.new()
		new_event.scancode = KeyNames[index-1]
		InputMap.action_add_event("move_forward", new_event)
	
func _on_Dropdown_1_item_selected(index):
	$"/root/Global".DefaultBinds[1] = AvailableKeys[index-1]
	
	for i in InputMap.get_action_list("move_backward"):
		InputMap.action_erase_event("move_backward", i)
	if AvailableKeys[index-1] == "Left Click":
		var new_event = InputEventMouseButton.new()
		new_event.button_index = BUTTON_LEFT
		InputMap.action_add_event("move_backward", new_event)
	elif AvailableKeys[index-1] == "Right Click":
		var new_event = InputEventMouseButton.new()
		new_event.button_index = BUTTON_RIGHT
		InputMap.action_add_event("move_backward", new_event)
	else:
		var new_event = InputEventKey.new()
		new_event.scancode = KeyNames[index-1]
		InputMap.action_add_event("move_backward", new_event)
	
func _on_Dropdown_2_item_selected(index):
	$"/root/Global".DefaultBinds[2] = AvailableKeys[index-1]
	
	for i in InputMap.get_action_list("move_left"):
		InputMap.action_erase_event("move_left", i)
	if AvailableKeys[index-1] == "Left Click":
		var new_event = InputEventMouseButton.new()
		new_event.button_index = BUTTON_LEFT
		InputMap.action_add_event("move_left", new_event)
	elif AvailableKeys[index-1] == "Right Click":
		var new_event = InputEventMouseButton.new()
		new_event.button_index = BUTTON_RIGHT
		InputMap.action_add_event("move_left", new_event)
	else:	
		var new_event = InputEventKey.new()
		new_event.scancode = KeyNames[index-1]
		InputMap.action_add_event("move_left", new_event)

func _on_Dropdown_3_item_selected(index):
	$"/root/Global".DefaultBinds[3] = AvailableKeys[index-1]
	
	for i in InputMap.get_action_list("move_right"):
		InputMap.action_erase_event("move_right", i)
	if AvailableKeys[index-1] == "Left Click":
		var new_event = InputEventMouseButton.new()
		new_event.button_index = BUTTON_LEFT
		InputMap.action_add_event("move_right", new_event)
	elif AvailableKeys[index-1] == "Right Click":
		var new_event = InputEventMouseButton.new()
		new_event.button_index = BUTTON_RIGHT
		InputMap.action_add_event("move_right", new_event)
	else:
		var new_event = InputEventKey.new()
		new_event.scancode = KeyNames[index-1]
		InputMap.action_add_event("move_right", new_event)

func _on_Dropdown_4_item_selected(index):
	$"/root/Global".DefaultBinds[4] = AvailableKeys[index-1]
	
	for i in InputMap.get_action_list("jump"):
		InputMap.action_erase_event("jump", i)
	if AvailableKeys[index-1] == "Left Click":
		var new_event = InputEventMouseButton.new()
		new_event.button_index = BUTTON_LEFT
		InputMap.action_add_event("jump", new_event)
	elif AvailableKeys[index-1] == "Right Click":
		var new_event = InputEventMouseButton.new()
		new_event.button_index = BUTTON_RIGHT
		InputMap.action_add_event("jump", new_event)
	else:
		var new_event = InputEventKey.new()
		new_event.scancode = KeyNames[index-1]
		InputMap.action_add_event("jump", new_event)

func _on_Dropdown_5_item_selected(index):
	$"/root/Global".DefaultBinds[5] = AvailableKeys[index-1]
	
	for i in InputMap.get_action_list("slide"):
		InputMap.action_erase_event("slide", i)
	if AvailableKeys[index-1] == "Left Click":
		var new_event = InputEventMouseButton.new()
		new_event.button_index = BUTTON_LEFT
		InputMap.action_add_event("slide", new_event)
	elif AvailableKeys[index-1] == "Right Click":
		var new_event = InputEventMouseButton.new()
		new_event.button_index = BUTTON_RIGHT
		InputMap.action_add_event("slide", new_event)
	else:
		var new_event = InputEventKey.new()
		new_event.scancode = KeyNames[index-1]
		InputMap.action_add_event("slide", new_event)

func _on_Dropdown_6_item_selected(index):
	$"/root/Global".DefaultBinds[6] = AvailableKeys[index-1]
	
	for i in InputMap.get_action_list("fire"):
		print(i)
		InputMap.action_erase_event("fire", i)
	if AvailableKeys[index-1] == "Left Click":
		var new_event = InputEventMouseButton.new()
		new_event.button_index = BUTTON_LEFT
		InputMap.action_add_event("fire", new_event)
	elif AvailableKeys[index-1] == "Right Click":
		var new_event = InputEventMouseButton.new()
		new_event.button_index = BUTTON_RIGHT
		InputMap.action_add_event("fire", new_event)
	else:
		var new_event = InputEventKey.new()
		new_event.scancode = KeyNames[index-1]
		InputMap.action_add_event("fire", new_event)

func _on_Dropdown_7_item_selected(index):
	$"/root/Global".DefaultBinds[7] = AvailableKeys[index-1]
	
	for i in InputMap.get_action_list("reset"):
		InputMap.action_erase_event("reset", i)
	if AvailableKeys[index-1] == "Left Click":
		var new_event = InputEventMouseButton.new()
		new_event.button_index = BUTTON_LEFT
		InputMap.action_add_event("reset", new_event)
	elif AvailableKeys[index-1] == "Right Click":
		var new_event = InputEventMouseButton.new()
		new_event.button_index = BUTTON_RIGHT
		InputMap.action_add_event("reset", new_event)
	else:
		var new_event = InputEventKey.new()
		new_event.scancode = KeyNames[index-1]
		InputMap.action_add_event("reset", new_event)

func _on_Dropdown_8_item_selected(index):
	$"/root/Global".DefaultBinds[8] = AvailableKeys[index-1]
	
	for i in InputMap.get_action_list("test_gun"):
		InputMap.action_erase_event("test_gun", i)
	if AvailableKeys[index-1] == "Left Click":
		var new_event = InputEventMouseButton.new()
		new_event.button_index = BUTTON_LEFT
		InputMap.action_add_event("test_gun", new_event)
	elif AvailableKeys[index-1] == "Right Click":
		var new_event = InputEventMouseButton.new()
		new_event.button_index = BUTTON_RIGHT
		InputMap.action_add_event("test_gun", new_event)
	else:
		var new_event = InputEventKey.new()
		new_event.scancode = KeyNames[index-1]
		InputMap.action_add_event("test_gun", new_event)

func _on_Dropdown_9_item_selected(index):
	$"/root/Global".DefaultBinds[9] = AvailableKeys[index-1]
	
	for i in InputMap.get_action_list("level_swap"):
		InputMap.action_erase_event("level_swap", i)
	if AvailableKeys[index-1] == "Left Click":
		var new_event = InputEventMouseButton.new()
		new_event.button_index = BUTTON_LEFT
		InputMap.action_add_event("level_swap", new_event)
	elif AvailableKeys[index-1] == "Right Click":
		var new_event = InputEventMouseButton.new()
		new_event.button_index = BUTTON_RIGHT
		InputMap.action_add_event("level_swap", new_event)
	else:
		var new_event = InputEventKey.new()
		new_event.scancode = KeyNames[index-1]
		InputMap.action_add_event("level_swap", new_event)

func _on_Dropdown_10_item_selected(index):
	$"/root/Global".DefaultBinds[10] = AvailableKeys[index-1]
	
	for i in InputMap.get_action_list("escape"):
		InputMap.action_erase_event("escape", i)
	if AvailableKeys[index-1] == "Left Click":
		var new_event = InputEventMouseButton.new()
		new_event.button_index = BUTTON_LEFT
		InputMap.action_add_event("escape", new_event)
	elif AvailableKeys[index-1] == "Right Click":
		var new_event = InputEventMouseButton.new()
		new_event.button_index = BUTTON_RIGHT
		InputMap.action_add_event("escape", new_event)
	else:
		var new_event = InputEventKey.new()
		new_event.scancode = KeyNames[index-1]
		InputMap.action_add_event("escape", new_event)
