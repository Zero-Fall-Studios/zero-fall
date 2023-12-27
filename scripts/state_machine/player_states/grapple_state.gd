class_name GrappleState
extends State

@export var grapple : Grapple
@export var using_controller = false
@export var CHAIN_PULL = 15

var chain_velocity := Vector2(0,0)

func enter() -> void:
	super()
	if using_controller:
		var input = parent.get_input()
		if input != Vector2.ZERO:
			grapple.shoot(input)
		else:
			grapple.shoot(Vector2(1, 0))
	else:
		grapple.shoot(parent.get_local_mouse_position())

func process_physics(delta: float) -> State:
	parent.apply_gravity(delta)
	
			# Hook physics
	if grapple.hooked:
		# `to_local(grapple.tip).normalized()` is the direction that the chain is pulling
		chain_velocity = parent.to_local(grapple.tip).normalized() * CHAIN_PULL
		if chain_velocity.y > 0:
			# Pulling down isn't as strong
			chain_velocity.y *= 0.55
		else:
			# Pulling up is stronger
			chain_velocity.y *= 1.65

		var input = parent.get_input()
		if sign(chain_velocity.x) != sign(input.x):
			# if we are trying to walk in a different
			# direction than the chain is pulling
			# reduce its pull
			chain_velocity.x *= 0.7
	else:
		# Not hooked -> no chain velocity
		chain_velocity = Vector2(0,0)

	parent.velocity_modifier = chain_velocity

		# Movement
	parent.apply_movement(delta)
	parent.move()

	if not Input.is_action_pressed('attack_primary'):
		return state_machine.states.get("FallState")

	return null

func exit() -> void:
	super()
	grapple.release()
	parent.velocity_modifier = Vector2(0,0)
