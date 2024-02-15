extends Node2D


var pawn_scene = preload("res://components/pieces/pawn/pawn.tscn")
var rook_scene = preload("res://components/pieces/rook/rook.tscn")
var knight_scene = preload("res://components/pieces/knight/knight.tscn")
var queen_scene = preload("res://components/pieces/queen/queen.tscn")
var bishop_scene = preload("res://components/pieces/bishop/bishop.tscn")
var king_scene = preload("res://components/pieces/king/king.tscn")

signal move_happened

# Signals up to GameUI that a promotion is happening
signal promotion
signal game_ended

# Signals to itself when GameUI is done
signal promotion_happened
signal check

# Signal to play move_sound
signal move_sound

# Stores the tile that a pawn jumped over (gets set by a pawn)
@export var allowed_en_passant: Tile
@export var taken_pieces_by_white: Array
@export var taken_pieces_by_black: Array
var current_player: Global.Players = Global.Players.WHITE


func clear_board():
	for child in $Pieces.get_children():
		child.current_tile.current_piece = null
		child.queue_free()


# Hexfen is the internal way to load game positions
func load_hexfen(fen: String):
	clear_board()
	# Contains an array of all "to be loaded" rank
	var ranks := fen.split(" ")[0].split("/")

	# Example hexfen (start position):
	# "1PRNQB/2P2BK/3P1B1N/4P3R/5PPPPP/Y/1ppppp/2r3p/3n1b1p/4qb2p/5bknrp w"
	# You can see the coordinate system by the names of the tile nodes (Naming scheme: x_y)
	# The system goes over each y rank, so 0_0, 1_0, 2_0 ... 0_1, 1_1, 2_1, ... 0_3, 1_3 ...
	# The / is a deliminator between ranks
	# Numbers represent skipped tiles
	# lowercases letters are black pieces
	# Uppercase letters are white pieces
	# P = Pawn
	# Q = Queen
	# R = Rook
	# N = Knight
	# K = King
	# B = Bishop
	
	# At the very end: the player whose turn it is
	# w = white
	# b = black
	var current_rank = 0
	# loop over ranks
	for rank in ranks:
		var current_file: int = 0
		for letter in rank.split():
			
			# Handle numbers
			if letter.is_valid_int():
				current_file += int(letter)
				continue
			if letter == "X":
				current_file += 10
				continue
			if letter == "Y":
				current_file += 11
				continue
			
			match letter:
				"p":
					load_piece(pawn_scene, Global.Players.BLACK, get_node("Tiles/" + str(current_file) + "_" + str(current_rank)))
				"P":
					load_piece(pawn_scene, Global.Players.WHITE, get_node("Tiles/" + str(current_file) + "_" + str(current_rank)))
				"r":
					load_piece(rook_scene, Global.Players.BLACK, get_node("Tiles/" + str(current_file) + "_" + str(current_rank)))
				"R":
					load_piece(rook_scene, Global.Players.WHITE, get_node("Tiles/" + str(current_file) + "_" + str(current_rank)))
				"n":
					load_piece(knight_scene, Global.Players.BLACK, get_node("Tiles/" + str(current_file) + "_" + str(current_rank)))
				"N":
					load_piece(knight_scene, Global.Players.WHITE, get_node("Tiles/" + str(current_file) + "_" + str(current_rank)))
				"q":
					load_piece(queen_scene, Global.Players.BLACK, get_node("Tiles/" + str(current_file) + "_" + str(current_rank)))
				"Q":
					load_piece(queen_scene, Global.Players.WHITE, get_node("Tiles/" + str(current_file) + "_" + str(current_rank)))
				"b":
					load_piece(bishop_scene, Global.Players.BLACK, get_node("Tiles/" + str(current_file) + "_" + str(current_rank)))
				"B":
					load_piece(bishop_scene, Global.Players.WHITE, get_node("Tiles/" + str(current_file) + "_" + str(current_rank)))
				"k":
					load_piece(king_scene, Global.Players.BLACK, get_node("Tiles/" + str(current_file) + "_" + str(current_rank)))
				"K":
					load_piece(king_scene, Global.Players.WHITE, get_node("Tiles/" + str(current_file) + "_" + str(current_rank)))
			current_file += 1
		current_rank += 1
	
	# 
	match fen.split(" ")[1]:
		"w":
			play_player_change_anim(current_player, Global.Players.WHITE)
			current_player = Global.Players.WHITE
		"b":
			play_player_change_anim(current_player, Global.Players.BLACK)
			current_player = Global.Players.BLACK


func load_piece(piece_scene: PackedScene, color: Global.Players, tile: Tile):
	var piece_node = piece_scene.instantiate()
	piece_node.piece_color = color
	piece_node.position = tile.position
	piece_node.current_tile = tile
	tile.current_piece = piece_node
	$Pieces.add_child(piece_node)


func get_tile_by_vector(vector: Vector2i) -> Tile:
	return get_node_or_null("Tiles/" + str(vector.x) + "_" + str(vector.y))


# Piece is the pawn that reached the back ranks. The pawn delets itself after execution of open_promotion_menu() is done
func open_promotion_menu(piece: BasePiece):
	# GameUI gets the promotion signal, does things, send promotion_happened back
	promotion.emit()
	match await promotion_happened:
		"N":
			load_piece(knight_scene, current_player, piece.current_tile)
		"R":
			load_piece(rook_scene, current_player, piece.current_tile)
		"Q":
			load_piece(queen_scene, current_player, piece.current_tile)
		"B":
			load_piece(bishop_scene, current_player, piece.current_tile)


func move_happened_func(en_passant: bool):
	var next_player
	match current_player:
		Global.Players.WHITE:
			next_player = Global.Players.BLACK
		Global.Players.BLACK:
			next_player = Global.Players.WHITE

	var is_check = is_king_in_check(next_player)
	var is_checkmate: bool = false
	if is_check:
		# Check if the king is checkmated
		is_checkmate = true
		for piece in $Pieces.get_children():
			if piece.piece_color != next_player:
				continue
			if piece.get_valid_moves() != []:
				is_checkmate = false
				break

		# Checkmate logic
		if is_checkmate:#
			# Wait .35 seconds for S U S P E N S I O N
			await get_tree().create_timer(.35).timeout
			get_king(next_player).play_checkmate_animation()
			await get_king(next_player).checkmate_anim_done
			game_ended.emit(current_player)
	
	if not is_checkmate:
		# Switch players
		var old_player = current_player
		current_player = next_player
		# The en_passant variable gets set by the pawn because it has the neccesary information
		if not en_passant:
			allowed_en_passant = null
		move_happened.emit(current_player)
		play_player_change_anim(old_player, current_player)
		if is_check:
			check.emit()
		else:
			move_sound.emit()


func is_king_in_check(piece_color: Global.Players):
	# Find king in question
	var king = get_king(piece_color)
	
	if king == null:
		push_error("King not present in scene.")
		return false
	
	var king_checks = king.get_check_tiles()
	# Check if there are pieces in the possible tiles
	for tile in king_checks.get("rook"):
		if tile.current_piece != null:
			if tile.current_piece is Rook or tile.current_piece is Queen:
				if tile.current_piece.piece_color != piece_color:
#					print("Rook check!")
					return true
	
	for tile in king_checks.get("bishop"):
		if tile.current_piece != null:
			if tile.current_piece is Bishop or tile.current_piece is Queen:
				if tile.current_piece.piece_color != piece_color:
					return true
	
	for tile in king_checks.get("pawn"):
		if tile.current_piece != null:
			if tile.current_piece is Pawn:
				if tile.current_piece.piece_color != piece_color:
					return true
	
	for tile in king_checks.get("knight"):
		if tile.current_piece != null:
			if tile.current_piece is Knight:
				if tile.current_piece.piece_color != piece_color:
					return true
	
	# If nothing returns true
	return false


func play_player_change_anim(old_player, new_player):
	if Global.play_board_rotation:
		if old_player != new_player:
			match old_player:
				Global.Players.WHITE:
					$AnimationPlayer.play("player_change_anim")
				Global.Players.BLACK:
					$AnimationPlayer.play_backwards("player_change_anim")
	# Change board direction without animation
	else:
		if old_player != new_player:
			match old_player:
				Global.Players.WHITE:
					rotation = 3.14159265
				Global.Players.BLACK:
					rotation = 0


# The promotion_piece_selected signals turns into promotion_happened. I have no idea why, this doesn't accomplish anything
func _on_game_ui_promotion_piece_selected(piece):
	promotion_happened.emit(piece)


func get_king(color):
	var king: King
	for child in $Pieces.get_children():
		if child is King and child.piece_color == color:
			return child


func _ready():
	load_hexfen("1PRNQB/2P2BK/3P1B1N/4P3R/5PPPPP/Y/1ppppp/2r3p/3n1b1p/4qb2p/5bknrp w")

# Checkmate position
#	load_hexfen("k5/7/8/9/10/3Q6/1R4/2R4/8/9/10 b")
