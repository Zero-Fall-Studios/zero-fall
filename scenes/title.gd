extends Node2D

@onready var animation_player : AnimationPlayer = $AnimationPlayer

@export var main_menu : MainMenu 
@export var label : Label

var on_title = true

func _ready():
	pass
	
func _unhandled_input(event):
	if not on_title:
		return
	if event.is_action_pressed("ui_accept"):
		show_menu()
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				show_menu()
				print("Left button was clicked at ", event.position)
		else:
			print("Left button was released")
		if event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			show_menu()
			print("Wheel down")

func show_menu():
	on_title = false
	animation_player.play("fade_out_label")
	main_menu.show_menu()