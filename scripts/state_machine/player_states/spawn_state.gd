class_name SpawnState
extends State

func enter() -> void:
	parent.is_dead = false
	parent.position = parent.spawn_position
	parent.health = 100
	parent.health_changed.emit(parent.health)
	parent.show()
	super()

func process_physics(_delta: float) -> State:
	parent.move()
	if parent.is_animation_running:
		return null
	return state_machine.states.get("IdleState")
