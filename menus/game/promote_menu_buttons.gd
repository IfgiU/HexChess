extends HBoxContainer


signal piece_selected(piece: String)

func _on_bishop_pressed():
	piece_selected.emit("B")


func _on_knight_pressed():
		piece_selected.emit("N")


func _on_queen_pressed():
		piece_selected.emit("Q")


func _on_rook_pressed():
		piece_selected.emit("R")


#func _input(event):
#	print("Wow!" + str(event))
