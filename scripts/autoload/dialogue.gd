extends Node

@onready var canvas_layer = $CanvasLayer
@onready var label = $CanvasLayer/PanelContainer/MarginContainer/Label
@onready var animation_player = $AnimationPlayer

func _ready() -> void:
	animation_player.play("fade_out")
	canvas_layer.hide()

func show_dialogues(dialogues: Array) -> void:
	canvas_layer.show()
	for dialogue in dialogues:
		label.text = dialogue["text"]
		animation_player.play("fade_in")
		await get_tree().create_timer(dialogue["duration"]).timeout
		animation_player.play("fade_out")
		await get_tree().create_timer(animation_player.current_animation_length).timeout
