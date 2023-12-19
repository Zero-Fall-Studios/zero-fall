extends Node

func get_input_movement(_character : Character):
	return Input.get_axis('move_left', 'move_right')