extends Control


@onready var timer: Timer = $AnimationSpawnTimer
var max_animations: int = 10
var random_piece_offset = 250


func _on_timer():
	if get_child_count() < max_animations:
		var animation_piece = preload("res://menus/main_menu/piece_animation/piece_animation.tscn").instantiate()
		# animation_piece is children of self, so own coordinates are automatically added
		animation_piece.position = 	Vector2(randi_range(-random_piece_offset, random_piece_offset),
											randi_range(-random_piece_offset, random_piece_offset))
		
		add_child(animation_piece)
	
	timer.start(randf_range(.5, 7))
	
