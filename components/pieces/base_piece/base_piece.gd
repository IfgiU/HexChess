# All pieces inherit from this one
extends Node2D
class_name BasePiece



@export var piece_color: Global.Players = Global.Players.WHITE
@export var current_tile: Tile
var being_dragged: bool = false
# How bigger should the figure get when dragging
var expand_by = 1.5

var valid_moves: Array[Tile]

signal move_done


# Called when the node enters the scene tree for the first time.
func _ready():
	# Color the piece
	match piece_color:
		Global.Players.BLACK:
			set_modulate(Global.black_pieces_color)
		Global.Players.WHITE:
			set_modulate(Global.white_pieces_color)
	
	if current_tile.current_piece != self:
		push_error("current_tile.current_piece not equal to self, overwritting")
		current_tile.current_piece = self
	
	move_done.connect($"../..".move_happened_func)
	$"../..".connect("move_happened", move_happened_func)
	
	piece_specific_ready()


# This gets executed by the move_happened signal (emitted from Board)
func move_happened_func(player):
	if Global.play_board_rotation:
		match player:
			Global.Players.BLACK:
				$AnimationPlayer.play("Test/player_change_anim")
			Global.Players.WHITE:
				$AnimationPlayer.play_backwards("Test/player_change_anim")
	else:
		match player:
			Global.Players.BLACK:
				rotation = 3.14159265
			Global.Players.WHITE:
				rotation = 0


# Pieces can overwrite this for own initializing (Used by pawn)
func piece_specific_ready():
	pass


# Gets overwritten by the pieces
func get_valid_moves():
	pass


# Gets executed when an input event happens in the proximity of the piece
func _on_area_2d_input_event(viewport, event, shape_idx):
	if event.is_action_pressed("drag_piece") and $"../..".current_player == piece_color:
		# Enables a part in _input()
		being_dragged = true
		$Texture.set_scale($Texture.get_scale()*expand_by)
		# Display this piece above ALL pieces
		z_index = 2
		
		# Mark all valid tiles
		valid_moves = get_valid_moves()
		for tile in valid_moves:
			tile.modulate = Color(1, 0, 0)


func _input(event):
	if being_dragged and event is InputEventMouseMotion:
		global_position = get_global_mouse_position()
	if event.is_action_released("drag_piece") and being_dragged:
		# Get all Tiles currently overlapping with the piece and send to let_go
		let_go($Area2D.get_overlapping_areas().map(get_node_parent))


func let_go(possible_nearest):
		# Reset some variables
		z_index = 0
		being_dragged = false
		$Texture.set_scale($Texture.get_scale()/expand_by)
		
		# In case other pieces are present
		possible_nearest = possible_nearest.filter(is_tile)
		
		# Find nearest tile
		var nearest_tile: Tile
		var shortest_distance: float = INF
		for tile in possible_nearest:
			if position.distance_to(tile.position) < shortest_distance:
				nearest_tile = tile
				shortest_distance = position.distance_to(tile.position)
		
		# If the piece is out of bounds nearest_tile could be null,
		# but because null isn't in valid_moves everything still works.
		if nearest_tile in valid_moves:
			move_happened(current_tile, nearest_tile)
			
		else: # return to the last position
			position = current_tile.position
		# Remove the markings
		for tile in valid_moves:
			tile.color_tile()


func is_tile(object):
	return object is Tile


func is_not_null(object):
	return object != null


# Returns true when the tile is occupied by a enemy piece or not occupied at all
func is_tile_not_friendly_occupied(tile):
	if tile.current_piece != null:
		if tile.current_piece.piece_color == piece_color:
			return false
	return true


func get_node_parent(object):
	return object.get_parent()


# Overwritten by pieces
func get_taken():
	pass


# Can be overwritten for custom behaviour (used by pawn)
func move_happened(old_tile: Tile, new_tile: Tile):
	if new_tile.current_piece != null:
		new_tile.current_piece.get_taken()
	position = new_tile.position
	current_tile.current_piece = null
	current_tile = new_tile
	current_tile.current_piece = self
	move_done.emit(false)


# Return false if a move to the specified tile puts the own king in check
func is_move_not_check_for_own_king(tile: Tile):
	# "Make" the move to check if king is in check. then move back
	# Save current position
	var actual_current_tile = current_tile
	var piece_on_tile = tile.current_piece
	# "Make" the move
	current_tile.current_piece = null
	current_tile = tile
	current_tile.current_piece = self
	var is_check: bool = $"../..".is_king_in_check(piece_color)
	# Reset
	current_tile = actual_current_tile
	current_tile.current_piece = self
	tile.current_piece = piece_on_tile
	return not is_check
