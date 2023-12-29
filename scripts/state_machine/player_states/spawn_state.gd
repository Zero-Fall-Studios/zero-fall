class_name SpawnState
extends State

func enter() -> void:
	parent.is_dead = false
	parent.position = parent.spawn_position
	parent.health = parent.health_start
	parent.health_changed.emit(parent.health, parent.health_start)
	parent.armor = parent.armor_start
	parent.armor_changed.emit(parent.armor, parent.armor_start)
	parent.show()
	super()

func process_physics(_delta: float) -> State:
	parent.move()
	if parent.is_animation_running:
		return null
	return state_machine.states.get("IdleState")
