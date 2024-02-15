extends BasePiece
class_name Bishop


func get_taken():
	match piece_color:
		Global.Players.WHITE:
			$"../..".taken_pieces_by_black.append("B")
		Global.Players.BLACK:
			$"../..".taken_pieces_by_white.append("b")
	queue_free()


func get_valid_moves() -> Array[Tile]:
	var possible_moves: Array[Tile]
	
	# Upper left
	var i: int = 1
	while true:
		var possible_tile = $"../..".get_tile_by_vector(current_tile.get_name_as_vector() + Vector2i(-i, i))
		if possible_tile == null:
			break
		if possible_tile.current_piece != null:
			if possible_tile.current_piece.piece_color == piece_color:
				break
			elif possible_tile.current_piece.piece_color != piece_color:
				possible_moves.append(possible_tile)
				break
		possible_moves.append(possible_tile)
		i += 1
	
	# Upper right
	i = 1
	while true:
		var possible_tile = $"../..".get_tile_by_vector(current_tile.get_name_as_vector() + Vector2i(i, i*2))
		if possible_tile == null:
			break
		if possible_tile.current_piece != null:
			if possible_tile.current_piece.piece_color == piece_color:
				break
			elif possible_tile.current_piece.piece_color != piece_color:
				possible_moves.append(possible_tile)
				break
		possible_moves.append(possible_tile)
		i += 1
	
	# Middle left
	i = 1
	while true:
		var possible_tile = $"../..".get_tile_by_vector(current_tile.get_name_as_vector() + Vector2i(-i*2, -i))
		if possible_tile == null:
			break
		if possible_tile.current_piece != null:
			if possible_tile.current_piece.piece_color == piece_color:
				break
			elif possible_tile.current_piece.piece_color != piece_color:
				possible_moves.append(possible_tile)
				break
		possible_moves.append(possible_tile)
		i += 1
	
	# Middle right
	i = 1
	while true:
		var possible_tile = $"../..".get_tile_by_vector(current_tile.get_name_as_vector() + Vector2i(i*2, i))
		if possible_tile == null:
			break
		if possible_tile.current_piece != null:
			if possible_tile.current_piece.piece_color == piece_color:
				break
			elif possible_tile.current_piece.piece_color != piece_color:
				possible_moves.append(possible_tile)
				break
		possible_moves.append(possible_tile)
		i += 1
	
	# Lower left
	i = 1
	while true:
		var possible_tile = $"../..".get_tile_by_vector(current_tile.get_name_as_vector() + Vector2i(-i, -i*2))
		if possible_tile == null:
			break
		if possible_tile.current_piece != null:
			if possible_tile.current_piece.piece_color == piece_color:
				break
			elif possible_tile.current_piece.piece_color != piece_color:
				possible_moves.append(possible_tile)
				break
		possible_moves.append(possible_tile)
		i += 1
	
	# Lower right
	i = 1
	while true:
		var possible_tile = $"../..".get_tile_by_vector(current_tile.get_name_as_vector() + Vector2i(i, -i))
		if possible_tile == null:
			break
		if possible_tile.current_piece != null:
			if possible_tile.current_piece.piece_color == piece_color:
				break
			elif possible_tile.current_piece.piece_color != piece_color:
				possible_moves.append(possible_tile)
				break
		possible_moves.append(possible_tile)
		i += 1

	# Remove tiles where king would be in check
	possible_moves = possible_moves.filter(is_move_not_check_for_own_king)
	
	return possible_moves
