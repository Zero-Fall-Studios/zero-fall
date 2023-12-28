@tool
extends Area2D
class_name Pickup
			
@export_group("Items")
@export var item_atlas: ItemAtlas
@export var item_index: int = 0
@export var random_item: bool = false
				
@export_group("Spawn Settings")
@export var autospawn: bool = false
@export var respawn_time: float = 0
@export var spawn_once_per_level: bool = false
@export var spawn_once_per_game: bool = false

@export_group("Pickup Events")
@export var random_item_on_pickup: bool = false
@export var pickup_on_collision: bool = true
@export var pickup_with_mouse_click: bool = true

@onready var sprite: Sprite2D = $Sprite2D
@onready var spawn_timer: Timer = $SpawnTimer
@onready var collision_shape: CollisionShape2D = $CollisionShape2D

var is_mouse_over = false
var center : Vector2
var local_collision_pos : Vector2
var item: Item

func _ready():
	item = item_atlas.get_item_at_index(item_index)
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)
	input_event.connect(_on_input_event)
	
	_set_pickup_texture()
	center.x = sprite.get_rect().size.x / 2
	center.y = sprite.get_rect().size.y / 2
	
	hide()
	collision_shape.disabled = true
	
	spawn_timer.wait_time = respawn_time
	spawn_timer.one_shot = spawn_once_per_level
	if autospawn:
		spawn_timer.start()
	
func _on_input_event(_viewport, _event, _shape_idx):
	if Input.is_action_just_pressed("left_click"):
		Input.set_default_cursor_shape(Input.CURSOR_POINTING_HAND)
		_pickup_handler(get_global_mouse_position())
	
func _pickup_handler(coords : Vector2):
	var items: Array[Item] = [item]

	PickupSignalBus.pickup_event.emit(coords, items)
			
	hide()
	collision_shape.disabled = true
	
	Input.set_default_cursor_shape(Input.CURSOR_ARROW)

	# Check if has in inventory 
	var has_item_in_inventory = false
	var cant_spawn = (has_item_in_inventory and spawn_once_per_game) or spawn_once_per_level

	if not cant_spawn:
		spawn_timer.start()
		
func _integrate_forces( state ):
	if(state.get_contact_count() >= 1):  #this check is needed or it will throw errors 
		local_collision_pos = state.get_contact_local_pos(0)

func _on_body_entered(_body):
	if pickup_on_collision:
		var collision_position = local_collision_pos + get_position()
		_pickup_handler(collision_position)
	
func _on_body_exited(_body):
	pass

func _on_timer_timeout():
	_spawn()
	
func _set_pickup_texture():
	if sprite and item:
		sprite.texture = item.texture

func _spawn():
	show()
	collision_shape.disabled = false
	spawn_timer.stop()
