extends CanvasLayer
class_name Pause

@onready var container : MarginContainer = $MarginContainer
@onready var settings_menu : SettingsMenu = $SettingsMenu

func _ready():
	container.hide()
	settings_menu.on_close.connect(_settings_menu_closed)

func _input(event):
	if event.is_action_pressed("cancel"):
		if get_tree().paused:
			container.hide()
		else:
			container.show()
		get_tree().paused = !get_tree().paused

func _on_button_quit_pressed():
	get_tree().quit()

func _on_button_settings_pressed():
	container.hide()
	settings_menu.fade_in()

func _on_button_back_pressed():
	container.hide()
	get_tree().paused = !get_tree().paused

func _settings_menu_closed():
	container.show()