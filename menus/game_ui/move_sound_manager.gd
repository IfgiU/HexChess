extends AudioStreamPlayer


@export var move_sounds: Array[AudioStream]


func play_move_sound(from_position: float = 0.0):
	stream = move_sounds.pick_random()
	play(from_position)
