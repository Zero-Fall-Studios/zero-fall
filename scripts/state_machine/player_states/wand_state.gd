class_name WandState
extends State

@export var Bullet : PackedScene
@export var muzzle : Node2D

func enter() -> void:
	super()
	shoot()
	
func process_physics(_delta: float) -> State:
	if state_machine.prev_state:
		return state_machine.prev_state
	return state_machine.states.get("IdleState")

func shoot():
	var b = Bullet.instantiate()
	b.global_position = muzzle.global_position
	if parent.use_mouse:
		var mouse_pos = parent.get_global_mouse_position()
		var dir = mouse_pos - muzzle.global_position
		b.start(parent.position, dir)
	else:
		var input = parent.get_input()
		if input != Vector2.ZERO:
			b.start(parent.position, input)
		else:
			b.start(parent.position, Vector2(1, 0))
	parent.add_child(b)

