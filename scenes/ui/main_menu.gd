extends CanvasLayer
class_name MainMenu

@onready var animation_player: AnimationPlayer = $AnimationPlayer

@export var settings_menu : SettingsMenu

func _ready():
	hide()

func show_menu():
	show()
	animation_player.play("fade_in")

func _on_button_play_pressed():
	SceneManager.goto_scene("res://scenes/levels/cyberplanet.tscn")
	
func _on_button_settings_pressed():
	settings_menu.fade_in()

func _on_button_quit_pressed():
	get_tree().quit()
