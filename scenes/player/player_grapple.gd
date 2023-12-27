extends CharacterBody2D

class_name PlayerGrapple

@onready var sprite : Sprite2D = $Sprite2D
@onready var animation_player : AnimationPlayer = $AnimationPlayer
@onready var muzzle : Node2D = $Muzzle

@onready var jump_audio_player : AudioStreamPlayer = $JumpAudioPlayer
@onready var shoot_audio_player : AudioStreamPlayer = $ShootAudioPlayer
@onready var land_audio_player : AudioStreamPlayer = $LandAudioPlayer
@onready var erosion_audio_player : AudioStreamPlayer = $ErosionAudioPlayer

@export var Bullet : PackedScene
@export var world_tilemap : TileMap
@export var lava_tilemap : TileMap

@export var JUMP_FORCE = 300			# Force applied on jumping
@export var MOVE_SPEED = 50			# Speed to walk with
@export var RUN_SPEED = 100			# Speed to walk with
@export var GRAVITY = 10				# Gravity applied every second
@export var MAX_SPEED = 2000			# Maximum speed the player is allowed to move
@export var FRICTION_AIR = 0.95		# The friction while airborne
@export var FRICTION_GROUND = 0.85	# The friction while on the ground
@export var CHAIN_PULL = 15

@export var using_controller = false

var chain_velocity := Vector2(0,0)
var can_jump = false			# Whether the player used their air-jump
var is_idle = false
var is_walking = false
var is_running = false
var is_falling = false
var is_jumping = false
var is_swinging = false
var is_grounded = false
var is_landed = false
var is_shooting = false

var health = 100

signal health_change(health)

func _ready():
	await get_tree().create_timer(.1).timeout
	health_change.emit(health)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("right_hand"):
		if using_controller:
			var input = get_input()
			if input != Vector2.ZERO:
				$Chain.shoot(input)
			else:
				$Chain.shoot(Vector2(1, 0))
		else:
			$Chain.shoot(get_local_mouse_position())
	elif event.is_action_released("right_hand"):
		$Chain.release()

func get_input():
	var input : Vector2 = Vector2.ZERO
	input.x = (Input.get_action_strength("move_right") - Input.get_action_strength("move_left"))
	input.y = (Input.get_action_strength("move_down") - Input.get_action_strength("move_up"))
	return input.normalized()

# This function is called every physics frame
func _physics_process(_delta: float) -> void:
	var input = get_input()
	
	# Falling
	velocity.y += GRAVITY

	# Hook physics
	if $Chain.hooked:
		can_jump = true
		# `to_local($Chain.tip).normalized()` is the direction that the chain is pulling
		chain_velocity = to_local($Chain.tip).normalized() * CHAIN_PULL
		if chain_velocity.y > 0:
			# Pulling down isn't as strong
			chain_velocity.y *= 0.55
		else:
			# Pulling up is stronger
			chain_velocity.y *= 1.65
		if sign(chain_velocity.x) != sign(input.x):
			# if we are trying to walk in a different
			# direction than the chain is pulling
			# reduce its pull
			chain_velocity.x *= 0.7
		is_swinging = true
	else:
		# Not hooked -> no chain velocity
		chain_velocity = Vector2(0,0)
		is_swinging = false

	velocity += chain_velocity

	# Walking
	var speed = RUN_SPEED if is_running else MOVE_SPEED
	var move_x = input.x * speed

	velocity.x += move_x
	
	_handle_flip()
	
	move_and_slide()
	
	velocity.x -= move_x		# take away the walk speed again
	
#	for i in get_slide_collision_count():
#		var collision = get_slide_collision(i)
#		print("Collided with: ", collision.get_collider().name)
#		var tile = collision.get_collider()
#		print(tile)
		
# Actually apply all the forces
	
	# ^ This is done so we don't build up walk speed over time

	# Manage friction and refresh jump and stuff
	velocity.y = clamp(velocity.y, -MAX_SPEED, MAX_SPEED)	# Make sure we are in our limits
	velocity.x = clamp(velocity.x, -MAX_SPEED, MAX_SPEED)
	
	is_grounded = is_on_floor()
	if is_grounded:
		
		if is_falling:
			is_landed = true
			land_audio_player.play()

		is_jumping = false
		is_falling = false
		velocity.x *= FRICTION_GROUND	# Apply friction only on x (we are not moving on y anyway)
		can_jump = true 				# We refresh our air-jump
		if velocity.y >= 5:		# Keep the y-velocity small such that
			velocity.y = 5		# gravity doesn't make this number huge
		if input.x == 0:
			is_idle = true
			is_running = false
			is_walking = false
		elif Input.is_action_pressed("run"):
			is_idle = false
			is_running = true
			is_walking = false
		else:
			is_idle = false
			is_running = false
			is_walking = true
	elif is_on_ceiling() and velocity.y <= -5:	# Same on ceilings
		velocity.y = -5

	# Apply air friction
	if !is_grounded:
		velocity.x *= FRICTION_AIR
		if velocity.y > 0:
			velocity.y *= FRICTION_AIR

	if velocity.y > 0:
		is_jumping = false
		is_falling = true

	# Jumping
	if Input.is_action_just_pressed("jump"):
		if is_grounded:
			velocity.y = -JUMP_FORCE	# Apply the jump-force
			is_jumping = true
			jump_audio_player.play()
			if is_running:
				animation_player.play("Flip")
			else:
				animation_player.play("Jump")
		elif can_jump:
			can_jump = false	# Used air-jumpas
			velocity.y = -JUMP_FORCE
			is_jumping = true
			jump_audio_player.play()
			if is_running:
				animation_player.play("Flip")
			else:
				animation_player.play("Jump")
			
	_update_animations()
	
	if Input.is_action_just_pressed("left_hand"):
		shoot()
#
	if lava_tilemap:
		var cell = lava_tilemap.local_to_map(position)
		var lava_tile_data = lava_tilemap.get_cell_tile_data(0, cell)

		if (lava_tile_data):
			erosion_audio_player.play()
			take_damage(1)		
		
func take_damage(amount):
	health -= amount
	if health < 0:
		position = Vector2(0, 0)
		health = 100
	health_change.emit(health)

func shoot():
	is_shooting = true
	animation_player.play("ShootRight")
	shoot_audio_player.play()
	var b = Bullet.instantiate()
	b.global_position = muzzle.global_position
	if using_controller:
		var input = get_input()
		if input != Vector2.ZERO:
			b.start(position, input)
		else:
			b.start(position, Vector2(1, 0))
	else:
		var mouse_pos = get_global_mouse_position()
		b.look_at(mouse_pos)
	add_child(b)
		
func _handle_flip():
	if using_controller:
		if(velocity.x > 0):
			scale.x = scale.y * 1
		elif(velocity.x < 0):
			scale.x = scale.y * -1
	else:
		var mouse_pos = get_global_mouse_position()
		if mouse_pos.x < position.x:
			scale.x = scale.y * -1
		else:
			scale.x = scale.y * 1
			
func _update_animations():
	
	if is_shooting:
		animation_player.play("ShootRight")
		await get_tree().create_timer(.2).timeout
		is_shooting = false
		return
	
	if is_jumping:
		return
		
	if is_falling:
		animation_player.play("Fall")
		return
		
	if is_landed:
		animation_player.play("Land")
		await get_tree().create_timer(.2).timeout
		is_landed = false
		return
		
	if is_walking:
		animation_player.play("Walk")
	elif is_running:
		animation_player.play("Run")	
	elif is_idle:
		animation_player.play("Idle")
	
	
