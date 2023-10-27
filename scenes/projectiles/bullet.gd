extends CharacterBody2D

@onready var animation_player : AnimationPlayer = $AnimationPlayer

@export var speed = 300
@export var weight = 1
@export var ground_break : PackedScene

var current_weight

func start(_position, _direction):
	position = _position
	rotation = _direction.angle()
	velocity = _direction * speed

func _ready():
	set_as_top_level(true)
	animation_player.play("Fire")
	current_weight = weight

func _physics_process(delta):
	var collision = move_and_collide(velocity * delta)
	if collision and not collision.get_collider().is_queued_for_deletion():
		var collider = collision.get_collider()
		if (collider is TileMap):
			var point = collision.get_position()
			var tile = collider.local_to_map(collider.to_local(point))
			collider.erase_cell(0, tile) 
			var g = ground_break.instantiate()
			g.position = point + Vector2(8, 8)
			get_parent().get_parent().add_child(g)
		current_weight -= 1
		if current_weight <= 0:
			queue_free()	
	
	

