extends Node2D

@onready var main_menu = $CanvasLayer/MainMenu
@onready var level_node = $Level

# Load the custom images for the mouse cursor
var arrow = load("res://assets/ui/Target.png")

func _ready():
	_load_level()
	Input.set_custom_mouse_cursor(arrow)


func _load_level():
	await get_tree().create_timer(1).timeout
	var level = load("res://scenes/levels/level2.tscn").instantiate()
	level_node.add_child(level)
	main_menu.hide()
