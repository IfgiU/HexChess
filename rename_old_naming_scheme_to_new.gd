# Not used, was used during development to rename the board tiles from an old naming scheme
@tool
extends Node2D


var done: bool = false


func _process(delta):
	if not done:
		for child in get_children():
			var name: String
			name += str(int(child.name.substr(0, 2)))
			name += "_"
			name += str(int(child.name.substr(2, 2)))
			child.name = name
		done = true
