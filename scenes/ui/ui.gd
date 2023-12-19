class_name UI
extends CanvasLayer
@onready var label_health : Label = $LabelHealth
@export var player : Character

func _ready():
	if player:
		player.health_changed.connect(_on_health_changed)

func _on_health_changed(health: int):
	label_health.text = "HP - " + str(health)
