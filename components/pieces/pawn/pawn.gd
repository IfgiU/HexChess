extends BasePiece
class_name Pawn


func get_taken():
	match piece_color:
		Global.Players.WHITE:
			$"../..".taken_pieces_by_black.append("P")
		Global.Players.BLACK:
			$"../..".taken_pieces_by_white.append("p")
	queue_free()


var direction: int
var starting_group_name: String


func piece_specific_ready():
	
	# Change starting tiles and movement direction
	match piece_color:
		Global.Players.WHITE:
			direction = 1
			starting_group_name += "P"
		Global.Players.BLACK:
			direction = -1
			starting_group_name += "p"
	starting_group_name += "_start"


func get_valid_moves():
	var possible_moves: Array[Tile]
	
	# If tile before pawn is free
	var possible_tile = $"../..".get_tile_by_vector(current_tile.get_name_as_vector() + Vector2i(0, 1*direction))
	if possible_tile.current_piece == null:
		# Add tile before pawn
		possible_moves.append(possible_tile)
		
		# Also check if we're on starting position
		if current_tile in get_tree().get_nodes_in_group(starting_group_name):
			# If so, is the tile 2 tiles away free?
			possible_tile = $"../..".get_tile_by_vector(current_tile.get_name_as_vector() + Vector2i(0, 2*direction))
			if possible_tile.current_piece == null:
				# Then add it
				possible_moves.append(possible_tile)
	
	# If side tile exists and is blocked by opponent or is allowed_en_passant, add it
	# left
	possible_tile = $"../..".get_tile_by_vector(current_tile.get_name_as_vector() + Vector2i(-1*direction, 0))
	if possible_tile != null:
		if possible_tile.current_piece != null:
			# check if enemy
			if possible_tile.current_piece.piece_color != piece_color:
				possible_moves.append(possible_tile)
		
		elif possible_tile == $"../..".allowed_en_passant:
			possible_moves.append(possible_tile)
	
	# right
	possible_tile = $"../..".get_tile_by_vector(current_tile.get_name_as_vector() + Vector2i(1*direction, 1*direction))
	if possible_tile != null:
		if possible_tile.current_piece != null:
			if possible_tile.current_piece.piece_color != piece_color:
				possible_moves.append(possible_tile)
		
		elif possible_tile == $"../..".allowed_en_passant:
			possible_moves.append(possible_tile)
	
	possible_moves = possible_moves.filter(is_move_not_check_for_own_king)
	return possible_moves


func move_happened(old_tile: Tile, new_tile: Tile):
	var en_passant: bool = false
	# Detect 2 tile move (x coordinate gets ignored because y cannot get higher by 2 and change x)
	if old_tile.get_name_as_vector().y+2*direction == new_tile.get_name_as_vector().y:
		en_passant = true
		$"../..".allowed_en_passant = $"../..".get_tile_by_vector(new_tile.get_name_as_vector() - Vector2i(0, 1*direction))
	
	if new_tile.current_piece != null:
		new_tile.current_piece.get_taken()
	
	# If en passant, find piece and delete it
	if new_tile == $"../..".allowed_en_passant:
		var possible_en_passant_piece = $"../..".get_tile_by_vector(new_tile.get_name_as_vector() + Vector2i(0, 1)).current_piece
		if possible_en_passant_piece != null: # Color check not required because it's impossible for another piece to occupy that tile
			possible_en_passant_piece.get_taken()
		else: # If it's not above it, it's under it.
			$"../..".get_tile_by_vector(new_tile.get_name_as_vector() + Vector2i(0, -1)).current_piece.get_taken()
		
	# Check if the tile before you exists
	if $"../..".get_tile_by_vector(new_tile.get_name_as_vector() + Vector2i(0, 1*direction)) != null:
		position = new_tile.position
		current_tile.current_piece = null
		current_tile = new_tile
		current_tile.current_piece = self

	# else promotion
	else:
		position = new_tile.position
		current_tile.current_piece = null
		current_tile = new_tile
		current_tile.current_piece = self
		await $"../..".open_promotion_menu(self)
		# current_tile.current_piece gets replaced in open_promotion_menu()
		queue_free()
	move_done.emit(en_passant)
