extends CanvasLayer
class_name SettingsMenu

@export var hide_on_start : bool = true

@onready var animation_player : AnimationPlayer = $AnimationPlayer

func _ready():
	if hide_on_start:
		hide()
		fade_out()
	
func fade_in():
	show()
#	animation_player.play("MoveIn")
	pass

func fade_out():
#	animation_player.play("MoveOut")
	pass

func _on_button_back_pressed():
	GameManager.pop_scene()

func _on_h_slider_value_changed(value):
	GameAudioManager.set_volume(0, value)

func _on_button_credits_pressed():
	GameManager.append_scene("credits_menu")
