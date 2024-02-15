extends BasePiece
class_name Knight


func get_taken():
	match piece_color:
		Global.Players.WHITE:
			$"../..".taken_pieces_by_black.append("N")
		Global.Players.BLACK:
			$"../..".taken_pieces_by_white.append("n")
	print("Knight taken!")
	queue_free()


func get_valid_moves() -> Array[Tile]:
	var possible_moves: Array[Tile]
	
	# Upper left
	possible_moves.append($"../..".get_tile_by_vector(current_tile.get_name_as_vector() + Vector2i(-2, 1)))
	possible_moves.append($"../..".get_tile_by_vector(current_tile.get_name_as_vector() + Vector2i(-1, 2)))
	
	# Upper right
	possible_moves.append($"../..".get_tile_by_vector(current_tile.get_name_as_vector() + Vector2i(1, 3)))
	possible_moves.append($"../..".get_tile_by_vector(current_tile.get_name_as_vector() + Vector2i(2, 3)))
	
	# Miidle left
	possible_moves.append($"../..".get_tile_by_vector(current_tile.get_name_as_vector() + Vector2i(-3, -1)))
	possible_moves.append($"../..".get_tile_by_vector(current_tile.get_name_as_vector() + Vector2i(-3, -2)))
	
	# Miidle right
	possible_moves.append($"../..".get_tile_by_vector(current_tile.get_name_as_vector() + Vector2i(3, 2)))
	possible_moves.append($"../..".get_tile_by_vector(current_tile.get_name_as_vector() + Vector2i(3, 1)))
	
	# Lower left
	possible_moves.append($"../..".get_tile_by_vector(current_tile.get_name_as_vector() + Vector2i(-1, -3)))
	possible_moves.append($"../..".get_tile_by_vector(current_tile.get_name_as_vector() + Vector2i(-2, -3)))
	
	# Lower right
	possible_moves.append($"../..".get_tile_by_vector(current_tile.get_name_as_vector() + Vector2i(2, -1)))
	possible_moves.append($"../..".get_tile_by_vector(current_tile.get_name_as_vector() + Vector2i(1, -2)))
	
	possible_moves = possible_moves.filter(is_not_null)
	possible_moves = possible_moves.filter(is_tile_not_friendly_occupied)
	
	# Remove tiles where king would be in check
	possible_moves = possible_moves.filter(is_move_not_check_for_own_king)
	
	return possible_moves
