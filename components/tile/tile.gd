class_name Tile
extends Node2D


enum TileColor {
	WHITE,
	GRAY,
	BLACK,
}

@export var color: TileColor
@export var current_piece: BasePiece
var second1: Color
var second2: Color

# Called when the node enters the scene tree for the first time.
func _ready():
	color_tile()


func get_name_as_vector() -> Vector2i:
	var x = int(name.get_slice("_", 0))
	var y = int(name.get_slice("_", 1))
	return Vector2i(x, y)


func color_tile():
	if Global.main_color_used:
		second1 = Global.main_color.lightened(.2)
		second2 = Global.main_color.lightened(.4)
	else:
		second1 = Global.secondary_color_1
		second2 = Global.secondary_color_2

	match color:
		TileColor.BLACK:
			set_modulate(Global.main_color)
		TileColor.GRAY:
			set_modulate(second1)
		TileColor.WHITE:
			set_modulate(second2)
