extends Node2D


# Signals back to Board
signal promotion_piece_selected


func _input(event):
	if event.is_action_pressed("debug_checkmate"):
		_on_game_ended(Global.EndState.BLACK)


func open_promotion_menu():
	var selected_piece = await $UI.open_promotion_menu()
	promotion_piece_selected.emit(selected_piece)


func _on_check():
	if Global.play_audio:
		$CheckSound.play()


func _on_move():
	if Global.play_audio:
		$MoveSound.play_move_sound()


func _on_game_ended(end_state: Global.EndState):
	match await $UI.show_game_end_screen(end_state):
		"quit":
			get_tree().change_scene_to_file("res://menus/main_menu/main_menu.tscn")
		"rematch":
			get_tree().reload_current_scene()


func _on_quit_pressed():
	get_tree().change_scene_to_file("res://menus/main_menu/main_menu.tscn")
