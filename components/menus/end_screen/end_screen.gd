extends PanelContainer


signal end_screen_action


@export var end_state: Global.EndState:
	
	set(value):
		end_state = value
		match end_state:
			
			Global.EndState.BLACK:
				%EndScreenContent/WinLabel.text = "Black won!"
				%EndScreenContent/SecondLabel.text = ""
				%EndScreenContent/WinnerKing.modulate = Global.black_pieces_color
				
			Global.EndState.WHITE:
				%EndScreenContent/WinLabel.text = "White won!"
				%EndScreenContent/SecondLabel.text = ""
				%EndScreenContent/WinnerKing.modulate = Global.white_pieces_color
				
			Global.EndState.BLACK_STALEMATE:
				%EndScreenContent/WinLabel.text = "Black stalemates!"
				%EndScreenContent/SecondLabel.text = "This counts as a 3/4 win for black"
				%EndScreenContent/WinnerKing.modulate = Global.black_pieces_color
				
			Global.EndState.WHITE_STALEMATE:
				%EndScreenContent/WinLabel.text = "White stalemates!"
				%EndScreenContent/SecondLabel.text = "This counts as a 3/4 win for white"
				%EndScreenContent/WinnerKing.modulate = Global.white_pieces_color


func _on_rematch_pressed():
	end_screen_action.emit("rematch")


func _on_quit_pressed():
	end_screen_action.emit("quit")


func _ready():
		var style_box := StyleBoxFlat.new()
		var radius = 50
		style_box.corner_radius_top_left = radius
		style_box.corner_radius_top_right = radius
		style_box.corner_radius_bottom_left = radius
		style_box.corner_radius_bottom_right = radius
		style_box.shadow_color = Color(0, 0, 0, 0.259)
		style_box.shadow_size = 50
		style_box.bg_color = Global.main_color
		add_theme_stylebox_override("panel", style_box)
		
