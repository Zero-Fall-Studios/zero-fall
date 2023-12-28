class_name DieState
extends State

func enter() -> void:
	super()
	parent.paralize(true)

func process_physics(_delta: float) -> State:
	if parent.is_animation_running:
		return null
	return state_machine.states.get("SpawnState")

func exit() -> void:
	super()
	parent.hide()
	parent.paralize(false)
