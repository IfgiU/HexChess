extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	# Set the visual control nodes to the right value stored in Global
	# Main Color Usage CheckBox
	$VBoxContainer/TabContainer/Graphics/UseMainColor.set_pressed(Global.main_color_used)
	# Main Color Picker
	$VBoxContainer/TabContainer/Graphics/MainColor/ColorPickerButton.set_pick_color(Global.main_color)
	# Secondary 1
	$VBoxContainer/TabContainer/Graphics/SecondaryColor1/ColorPickerButton.set_pick_color(Global.secondary_color_1)
	# Secondary 2
	$VBoxContainer/TabContainer/Graphics/SecondaryColor2/ColorPickerButton.set_pick_color(Global.secondary_color_2)
	# White Pieces Color
	$VBoxContainer/TabContainer/Graphics/WhitePiecesColor/ColorPickerButton.set_pick_color(Global.white_pieces_color)
	# Black Pieces Color
	$VBoxContainer/TabContainer/Graphics/BlackPiecesColor/ColorPickerButton.set_pick_color(Global.black_pieces_color)
	# Play board rotation
	$VBoxContainer/TabContainer/Graphics/PlayAnim.button_pressed = Global.play_board_rotation
	# Audio toggle
	$VBoxContainer/TabContainer/Audio/PlayAudio.button_pressed = Global.play_audio


func save_and_quit():
	# Read out the visual control nodes and set the Global values to them
	# Main Color Usage CheckBox
	Global.main_color_used = $VBoxContainer/TabContainer/Graphics/UseMainColor.is_pressed()
	# Main Color Picker
	Global.main_color = $VBoxContainer/TabContainer/Graphics/MainColor/ColorPickerButton.get_pick_color()
	# Secondary 1 Color Picker
	Global.secondary_color_1 = $VBoxContainer/TabContainer/Graphics/SecondaryColor1/ColorPickerButton.get_pick_color()
	# Secondary 2 Color Picker
	Global.secondary_color_2 = $VBoxContainer/TabContainer/Graphics/SecondaryColor2/ColorPickerButton.get_pick_color()
	# White Pieces Colorr
	Global.white_pieces_color = $VBoxContainer/TabContainer/Graphics/WhitePiecesColor/ColorPickerButton.get_pick_color()
	# Black Pieces Color
	Global.black_pieces_color = $VBoxContainer/TabContainer/Graphics/BlackPiecesColor/ColorPickerButton.get_pick_color()
	# Play player changing animation
	Global.play_board_rotation = $VBoxContainer/TabContainer/Graphics/PlayAnim.button_pressed
	# Play audio
	Global.play_audio = $VBoxContainer/TabContainer/Audio/PlayAudio.button_pressed
	
	# Save to config
	# Doesnt work
	#Global.save_config()
	get_tree().change_scene_to_file("res://menus/main_menu/main_menu.tscn")
