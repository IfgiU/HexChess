extends Sprite2D


@export var possible_textures: Array[Texture2D]


func _ready():
	texture = possible_textures.pick_random()
	# Randomise black/white piece
	if randi_range(0, 1) == 1:
		set_modulate(Global.black_pieces_color)
	else:
		set_modulate(Global.white_pieces_color)
	
	var animation = create_tween().set_parallel().set_speed_scale(randf_range(.1, .2))
	
	# size animation
	var start_size: = .2
	var end_size: = randf_range(2.5, 3)
	scale = Vector2(start_size, start_size)
	animation.tween_property($".", "scale", Vector2(end_size, end_size), 1)
	
	# rotation
	animation.tween_property($".", "rotation", randf_range(-8, 8), 1)
	
	# fade out
	var final_color = modulate
	final_color.a = 0
	animation.tween_property($".", "modulate", final_color, 1)
	
	# kill object
	animation.tween_callback(queue_free).set_delay(1.1)
