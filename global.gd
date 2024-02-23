# Contains global variables and other globally accessed things
extends Node


# Graphic settings
@export var main_color_used: bool = true
@export_color_no_alpha var main_color: Color = Color("#cd8200")
@export_color_no_alpha var secondary_color_1: Color
@export_color_no_alpha var secondary_color_2: Color
@export_color_no_alpha var background_color: Color = Color("#1d0701"):
	set(new_color):
		RenderingServer.set_default_clear_color(new_color)
@export_color_no_alpha var black_pieces_color: Color = Color("#7D4F00")
@export_color_no_alpha var white_pieces_color: Color = Color(1, 1, 1)

# Audio
@export var play_audio: bool = true

# Animation
@export var play_board_rotation: bool = true

# Config object (Not the file itself!)
var config = ConfigFile.new()

enum Players {
	WHITE,
	BLACK
}

enum EndState {
	WHITE,
	BLACK,
	WHITE_STALEMATE,
	BLACK_STALEMATE,
	DRAW
}


func _ready():
	# Doesnt work
	#load_config()
	# The set() method needs to get executed, so this sets it to the default value
	background_color = background_color


func load_config():
	# Try to load config
	var err = config.load("user://config.cfg")
	if err != OK:
		return err

	# Sections: Graphics, Animation, Audio
	play_audio = config.get_value("Audio", "play_audio", play_audio)
	main_color = config.get_value("Graphics", "main_color", main_color)
	main_color_used = config.get_value("Graphics", "main_color_used", main_color_used)
	secondary_color_1 = config.get_value("Graphics", "color2", secondary_color_1)
	secondary_color_2 = config.get_value("Graphics", "color3", secondary_color_2)
	black_pieces_color = config.get_value("Graphics", "black_pieces_color", black_pieces_color)
	white_pieces_color = config.get_value("Graphics", "white_pieces_color", white_pieces_color)


func save_config():
	# Sections: Graphics, Animation, Audio
	config.set_value("Audio", "play_audio", play_audio)
	config.set_value("Graphics", "main_color", main_color)
	config.set_value("Graphics", "main_color_used", main_color_used)
	config.set_value("Graphics", "color2", secondary_color_1)
	config.set_value("Graphics", "color3", secondary_color_2)
	config.set_value("Graphics", "black_pieces_color", black_pieces_color)
	config.set_value("Graphics", "white_pieces_color", white_pieces_color)
