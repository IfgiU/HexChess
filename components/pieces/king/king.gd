extends BasePiece
class_name King


signal checkmate_anim_done


func get_taken():
	push_error("King was taken")


func get_valid_moves() -> Array[Tile]:
	var possible_moves: Array[Tile]
	
	# Get all moves possible on infinite free space
	possible_moves.append($"../..".get_tile_by_vector(current_tile.get_name_as_vector() + Vector2i(0, -1)))
	possible_moves.append($"../..".get_tile_by_vector(current_tile.get_name_as_vector() + Vector2i(0, 1)))
	possible_moves.append($"../..".get_tile_by_vector(current_tile.get_name_as_vector() + Vector2i(-1, 0)))
	possible_moves.append($"../..".get_tile_by_vector(current_tile.get_name_as_vector() + Vector2i(1, 0)))
	possible_moves.append($"../..".get_tile_by_vector(current_tile.get_name_as_vector() + Vector2i(-1, -1)))
	possible_moves.append($"../..".get_tile_by_vector(current_tile.get_name_as_vector() + Vector2i(-2, -1)))
	possible_moves.append($"../..".get_tile_by_vector(current_tile.get_name_as_vector() + Vector2i(-1, -2)))
	possible_moves.append($"../..".get_tile_by_vector(current_tile.get_name_as_vector() + Vector2i(-1, 1)))
	possible_moves.append($"../..".get_tile_by_vector(current_tile.get_name_as_vector() + Vector2i(1, -1)))
	possible_moves.append($"../..".get_tile_by_vector(current_tile.get_name_as_vector() + Vector2i(1, 1)))
	possible_moves.append($"../..".get_tile_by_vector(current_tile.get_name_as_vector() + Vector2i(1, 2)))
	possible_moves.append($"../..".get_tile_by_vector(current_tile.get_name_as_vector() + Vector2i(2, 1)))
	
	# Filter the invalid moves
	possible_moves = possible_moves.filter(is_not_null)
	possible_moves = possible_moves.filter(is_tile_not_friendly_occupied)
	
	# Remove tiles where king would be in check
	possible_moves = possible_moves.filter(is_move_not_check_for_own_king)
	
	return possible_moves


# The king turns into a queen and knight Frankenstein monster, being able to move like all pieces combined.
# Then, it checks which tiles it can move to and returns them
func get_check_tiles() -> Dictionary:
	var check_tiles: Dictionary
	
	# Knight
	# Upper left
	var knight_checks: Array
	knight_checks.append($"../..".get_tile_by_vector(current_tile.get_name_as_vector() + Vector2i(-2, 1)))
	knight_checks.append($"../..".get_tile_by_vector(current_tile.get_name_as_vector() + Vector2i(-1, 2)))
	
	# Upper right
	knight_checks.append($"../..".get_tile_by_vector(current_tile.get_name_as_vector() + Vector2i(1, 3)))
	knight_checks.append($"../..".get_tile_by_vector(current_tile.get_name_as_vector() + Vector2i(2, 3)))
	
	# Miidle left
	knight_checks.append($"../..".get_tile_by_vector(current_tile.get_name_as_vector() + Vector2i(-3, -1)))
	knight_checks.append($"../..".get_tile_by_vector(current_tile.get_name_as_vector() + Vector2i(-3, -2)))
	
	# Miidle right
	knight_checks.append($"../..".get_tile_by_vector(current_tile.get_name_as_vector() + Vector2i(3, 2)))
	knight_checks.append($"../..".get_tile_by_vector(current_tile.get_name_as_vector() + Vector2i(3, 1)))
	
	# Lower left
	knight_checks.append($"../..".get_tile_by_vector(current_tile.get_name_as_vector() + Vector2i(-1, -3)))
	knight_checks.append($"../..".get_tile_by_vector(current_tile.get_name_as_vector() + Vector2i(-2, -3)))
	
	# Lower right
	knight_checks.append($"../..".get_tile_by_vector(current_tile.get_name_as_vector() + Vector2i(2, -1)))
	knight_checks.append($"../..".get_tile_by_vector(current_tile.get_name_as_vector() + Vector2i(1, -2)))
	
	knight_checks = knight_checks.filter(is_not_null)
	check_tiles["knight"] = knight_checks
	
	var bishop_checks: Array
	
	var i: int = 1
	while true:
		var possible_tile = $"../..".get_tile_by_vector(current_tile.get_name_as_vector() + Vector2i(-i, i))
		if possible_tile == null:
			break
		if possible_tile.current_piece != null:
			if possible_tile.current_piece.piece_color == piece_color:
				break
			elif possible_tile.current_piece.piece_color != piece_color:
				bishop_checks.append(possible_tile)
				break
		bishop_checks.append(possible_tile)
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
				bishop_checks.append(possible_tile)
				break
		bishop_checks.append(possible_tile)
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
				bishop_checks.append(possible_tile)
				break
		bishop_checks.append(possible_tile)
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
				bishop_checks.append(possible_tile)
				break
		bishop_checks.append(possible_tile)
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
				bishop_checks.append(possible_tile)
				break
		bishop_checks.append(possible_tile)
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
				bishop_checks.append(possible_tile)
				break
		bishop_checks.append(possible_tile)
		i += 1
		
	check_tiles["bishop"] = bishop_checks
		
	var rook_checks: Array
		
	i = 1
	while true:
		var possible_tile = $"../..".get_tile_by_vector(current_tile.get_name_as_vector() + Vector2i(-i, 0))
		if possible_tile == null:
			break
		if possible_tile.current_piece != null:
			if possible_tile.current_piece.piece_color == piece_color:
				break
			elif possible_tile.current_piece.piece_color != piece_color:
				rook_checks.append(possible_tile)
				break
		rook_checks.append(possible_tile)
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
				rook_checks.append(possible_tile)
				break
		rook_checks.append(possible_tile)
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
				rook_checks.append(possible_tile)
				break
		rook_checks.append(possible_tile)
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
				rook_checks.append(possible_tile)
				break
		rook_checks.append(possible_tile)
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
				rook_checks.append(possible_tile)
				break
		rook_checks.append(possible_tile)
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
				rook_checks.append(possible_tile)
				break
		rook_checks.append(possible_tile)
		i += 1
	
	check_tiles["rook"] = rook_checks
	
	var pawn_checks: Array
	match piece_color:
		Global.Players.WHITE:
			pawn_checks.append($"../..".get_tile_by_vector(current_tile.get_name_as_vector() + Vector2i(-1, 0)))
			pawn_checks.append($"../..".get_tile_by_vector(current_tile.get_name_as_vector() + Vector2i(1, 1)))
		Global.Players.BLACK:
			pawn_checks.append($"../..".get_tile_by_vector(current_tile.get_name_as_vector() + Vector2i(-1, -1)))
			pawn_checks.append($"../..".get_tile_by_vector(current_tile.get_name_as_vector() + Vector2i(1, 0)))
	
	check_tiles["pawn"] = pawn_checks.filter(is_not_null)
#	print("Tile: " + str(current_tile) + " " + str(check_tiles["rook"]))
	return check_tiles


func play_checkmate_animation():
	$AnimationPlayer.play("King/king_checkmate")
	await $AnimationPlayer.animation_finished
	checkmate_anim_done.emit()
