class_name SpawnState
extends State

func process_physics(_delta: float) -> State:
	if not parent.is_visible_in_tree() and not parent.is_animation_running:
		return state_machine.states.get("IdleState")
	return null
