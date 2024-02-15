extends BasePiece
class_name Rook


func get_taken():
	match piece_color:
		Global.Players.WHITE:
			$"../..".taken_pieces_by_black.append("R")
		Global.Players.BLACK:
			$"../..".taken_pieces_by_white.append("r")
	queue_free()


func get_valid_moves():
	var possible_moves: Array[Tile]
	
	# Upper left
	var i: int = 1
	while true:
		var possible_tile = $"../..".get_tile_by_vector(current_tile.get_name_as_vector() + Vector2i(-i, 0))
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
		
	# Upper middle
	i = 1
	while true:
		var possible_tile = $"../..".get_tile_by_vector(current_tile.get_name_as_vector() + Vector2i(0, i))
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
		var possible_tile = $"../..".get_tile_by_vector(current_tile.get_name_as_vector() + Vector2i(i, i))
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
		var possible_tile = $"../..".get_tile_by_vector(current_tile.get_name_as_vector() + Vector2i(-i, -i))
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
		
	# Lower middle
	i = 1
	while true:
		var possible_tile = $"../..".get_tile_by_vector(current_tile.get_name_as_vector() + Vector2i(0, -i))
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
		var possible_tile = $"../..".get_tile_by_vector(current_tile.get_name_as_vector() + Vector2i(i, 0))
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
