extends Sprite2D


@export var possible_textures: Array[Texture2D]


func _ready():
	# Randomise speed
	# Randomise texture
	texture = possible_textures.pick_random()
	# Randomise black/white piece
	set_modulate(Global.black_pieces_color)
	pass
