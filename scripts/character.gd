class_name Character
extends CharacterBody2D

@onready var animation_player : AnimationPlayer = $AnimationPlayer
@onready var state_machine = $StateMachine
@onready var sprite = $Sprite2D
@onready var collision_shape = $CollisionShape2D

@export_category("Movement")
@export var move_speed: float = 400
@export var run_modifier: float = 1.5
@export var MAX_SPEED = 2000

@export_category("Jumping")
@export var jumps: int = 1
@export var jump_force: float = 900.0

@export_category("Pushing")
@export var push_force: float = 80.0

@export_category("Friction")
@export var wall_friction: float = 0.9
@export var ground_friction: float = 0.9
@export var air_friction: float = 0.5

@export_category("Spawn")
@export var spawn_on_start: bool = false
@export var turn_left_on_start: bool = false

@export_category("Controls")
@export var controls : Node
@export var using_controller = false

@export_category("Inventory")
@export var inventory : Inventory

@export var lava_tilemap : TileMap

@onready var jump_audio_player : AudioStreamPlayer = $JumpAudioPlayer
@onready var shoot_audio_player : AudioStreamPlayer = $ShootAudioPlayer
@onready var land_audio_player : AudioStreamPlayer = $LandAudioPlayer
@onready var erosion_audio_player : AudioStreamPlayer = $ErosionAudioPlayer

var jumps_left = 0
var is_animation_running : bool = false
var gravity: int = ProjectSettings.get_setting("physics/2d/default_gravity")
var movement : float = 0
var direction : Vector2 = Vector2(1, 0)
var velocity_modifier : Vector2 = Vector2(0, 0)
var facing_direction : float = 1
var paralized : bool = false
var health = 100
var weapons

enum Abilities {
	Walk,
	Run,
	Jump,
	JumpFlip,
	AttackPrimary,
	AttackSecondary,
	Crouch,
	WallJump
}

signal health_changed(health: int)

func _ready():
	hide()
	state_machine.init(self)
	animation_player.animation_started.connect(_on_animation_started)
	animation_player.animation_finished.connect(_on_animation_finished)

	weapons = get_tree().get_nodes_in_group("weapon")

	if turn_left_on_start:
		change_dir(-1)

	if spawn_on_start:
		spawn(position)

func _unhandled_input(event: InputEvent) -> void:
	if paralized:
		return
	state_machine.process_input(event)

func _physics_process(delta: float) -> void:
	state_machine.process_physics(delta)

	if lava_tilemap:
		var cell = lava_tilemap.local_to_map(position)
		var lava_tile_data = lava_tilemap.get_cell_tile_data(0, cell)

		if (lava_tile_data):
			erosion_audio_player.play()
			take_damage(1)	

func _process(delta: float) -> void:
	state_machine.process_frame(delta)
		
func _on_animation_started(_anim_name: StringName):
	is_animation_running = true
	
func _on_animation_finished(_anim_name: StringName):
	is_animation_running = false
	
func spawn(pos):
	position = pos
	show()
	health_changed.emit(health)
	animation_player.play("Spawn")
	await animation_player.animation_finished
	state_machine.change_state(state_machine.states.get("IdleState"))

func take_damage(amount):
	health -= amount
	if health < 0:
		position = Vector2(0, 0)
		health = 100
	health_changed.emit(health)

func kill():
	state_machine.change_state(state_machine.states.get("DieState"))

func apply_gravity(delta: float):
	velocity.y += gravity * delta

func apply_movement(_delta: float):
	movement = get_movement()

	var speed = movement * move_speed

	var friction = get_friction()

	if is_running() or is_jump_flipping():
		speed = speed * run_modifier

	velocity.x = speed * friction

	velocity += velocity_modifier

	# Manage friction and refresh jump and stuff
	velocity.y = clamp(velocity.y, -MAX_SPEED, MAX_SPEED)	# Make sure we are in our limits
	velocity.x = clamp(velocity.x, -MAX_SPEED, MAX_SPEED)

	handle_flip()

func handle_flip():
	if using_controller:
		if velocity.x > 0:
			scale.x = scale.y * 1
			facing_direction = 1
		elif velocity.x < 0:
			scale.x = scale.y * -1
			facing_direction = -1
	else:
		var mouse_pos = get_global_mouse_position()
		if mouse_pos.x < position.x:
			scale.x = scale.y * -1
			facing_direction = -1
		else:
			scale.x = scale.y * 1
			facing_direction = 1

func change_dir(dir: float):
	if dir != facing_direction:
		facing_direction = dir
		scale.x = -1

func get_friction():
	if is_on_floor():
		return ground_friction
	elif is_wall_clinging():
		return wall_friction
	else:
		return air_friction

func apply_jump():
	jumps_left = jumps_left - 1
	velocity.y = -jump_force

func move():
	move_and_slide()

func get_movement():
	if paralized:
		return 0
	return controls.get_input_movement(self)

func get_input():
	if paralized:
		return 0
	return controls.get_input()

func is_idle():
	return is_on_floor() and not is_moving() and not is_on_wall()

func is_moving():
	return movement != 0

func is_wall_clinging():
	return false
	# return is_on_wall() and is_moving()

func is_falling():
	return velocity.y > 0 and !is_on_floor() and !is_wall_clinging()

func is_pushing_idle():
	return false
	# return is_on_floor() and is_on_wall()

func is_pushing():
	return false
	# return is_on_floor() and is_on_wall() and is_moving()

func is_running():
	return state_machine.current_state == state_machine.states.get("RunState")

func is_jump_flipping():
	return state_machine.current_state == state_machine.states.get("JumpFlipState")

func landed_on_floor():
	jumps_left = jumps

func can_jump():
	if is_on_floor() and jumps_left <= 0:
		jumps_left = jumps
	return jumps_left > 0

func get_input_just_pressed(abilities: Array[Abilities]) -> State:

	if paralized:
		return

	if Abilities.Jump in abilities:
		if Input.is_action_just_pressed('jump') and can_jump():
			if Abilities.JumpFlip in abilities and is_moving():
				return state_machine.states.get("JumpFlipState")
			return state_machine.states.get("JumpState")
	
	if Abilities.AttackPrimary in abilities:
		if Input.is_action_just_pressed('attack_primary'):
			return handle_attack_primary()

	if Abilities.AttackSecondary in abilities:
		if Input.is_action_just_pressed('attack_secondary'):
			return handle_attack_secondary()

	if Abilities.Crouch in abilities:
		if Input.is_action_just_pressed('crouch'):
				if not is_moving():
					return state_machine.states.get("CrouchIdleState")
				else:
					return state_machine.states.get("CrouchWalkState")

	if Abilities.WallJump in abilities:
		if Input.is_action_just_pressed('jump') and is_on_wall():
			return state_machine.states.get("WallJumpState")

	return null

func get_input_pressed(abilities: Array[Abilities]) -> State:

	if paralized:
		return

	if Abilities.Run in abilities:
		if (Input.is_action_pressed('move_left') or Input.is_action_pressed('move_right')) and Input.is_action_pressed('run'):
			if is_on_floor():	
				return state_machine.states.get("RunState")

	if Abilities.Walk in abilities:
		if (Input.is_action_pressed('move_left') or Input.is_action_pressed('move_right')) and not Input.is_action_pressed('run'):
			if is_on_floor():
				return state_machine.states.get("WalkState")

	if Abilities.Crouch in abilities:
		if Input.is_action_pressed('crouch'):
				if not is_moving():
					return state_machine.states.get("CrouchIdleState")
				else:
					return state_machine.states.get("CrouchWalkState")

	return null


func paralize(p : bool):
	velocity.x = 0
	velocity.y = 0
	paralized = p
	if paralized:
		animation_player.pause()
	else:
		animation_player.play()

func get_weapon_primary():
	if not inventory.equipment.left_hand:
		return null
	for weapon in weapons:
		if weapon.name == inventory.equipment.left_hand.name:
			return inventory.equipment.left_hand
	return null

func get_weapon_secondary():
	if not inventory.equipment.right_hand:
		return null
	for weapon in weapons:
		if weapon.name == inventory.equipment.right_hand.name:
			return inventory.equipment.right_hand
	return null

func handle_attack_primary():
	var weapon_primary = get_weapon_primary()
	if not weapon_primary:
		return null
	return state_machine.states.get(weapon_primary.state_name)

func handle_attack_secondary():
	var weapon_secondary = get_weapon_secondary()
	if not weapon_secondary:
		return null
	return state_machine.states.get(weapon_secondary.state_name)