extends CanvasLayer


@onready var promotion_menu = $Promotion/MarginContainer/PanelContainer/MarginContainer/HBoxContainer
func open_promotion_menu():
	$Promotion.visible = true
#	$Promotion/MarginContainer/ColorRect.modulate = Global.main_color
	
	match $"../Board".current_player:
		Global.Players.WHITE:
			promotion_menu.modulate = Global.white_pieces_color
		Global.Players.BLACK:
			promotion_menu.modulate = Global.black_pieces_color
	var selected_piece = await promotion_menu.piece_selected
	$Promotion.visible = false
	return selected_piece


func show_game_end_screen(end_state: Global.EndState):
	$EndScreen.visible = true
	$EndScreen.end_state = end_state
	$AnimationPlayer.play("EndScreen_popup")
	var end_screen_action = await $EndScreen.end_screen_action
	$EndScreen.visible = false
	return end_screen_action



