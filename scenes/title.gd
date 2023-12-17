extends Node2D

@onready var animation_player : AnimationPlayer = $AnimationPlayer

@export var main_menu : MainMenu 
@export var label : Label

var on_title = true

func _ready():
	SceneManager.show_black_screen()
	await get_tree().create_timer(1).timeout
	animation_player.play("fade_in")
	SceneManager.fade_out()
	await get_tree().create_timer(1).timeout
	animation_player.play("blink")
	
func _unhandled_input(event):
	if event.is_action_pressed("ui_accept") and on_title:
		on_title = false
		animation_player.play("fade_out_label")
		main_menu.show_menu()
