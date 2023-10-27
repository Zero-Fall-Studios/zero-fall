extends Node2D

@onready var animation_player : AnimationPlayer = $AnimationPlayer

func _ready():
	animation_player.play("Break")
	await get_tree().create_timer(.5).timeout
	queue_free()
