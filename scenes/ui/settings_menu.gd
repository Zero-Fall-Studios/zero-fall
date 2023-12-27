extends CanvasLayer
class_name SettingsMenu

@export var hide_on_start : bool = true

@onready var animation_player : AnimationPlayer = $AnimationPlayer
@onready var use_mouse_checkbox : CheckBox = $MarginContainer/Panel/CheckBox

signal on_close

func _ready():
	if hide_on_start:
		hide()
	use_mouse_checkbox.button_pressed = GameManager.game_data.use_mouse
	
func fade_in():
	show()
	animation_player.play("fade_in")

func fade_out():
	animation_player.play("fade_out")
	await animation_player.animation_finished
	hide()
	on_close.emit()

func _on_button_back_pressed():
	fade_out()

func _on_h_slider_value_changed(value):
	GameAudioManager.set_volume(0, value)

func _on_check_box_toggled(toggled_on:bool):
	GameManager.game_data.use_mouse = toggled_on
	GameManager.save_game_data()
