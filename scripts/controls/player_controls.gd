extends Node

func get_input_movement(_character : Character):
	return Input.get_axis('move_left', 'move_right')

func get_input():
	var input : Vector2 = Vector2.ZERO
	input.x = (Input.get_action_strength("move_right") - Input.get_action_strength("move_left"))
	input.y = (Input.get_action_strength("move_down") - Input.get_action_strength("move_up"))
	return input.normalized()