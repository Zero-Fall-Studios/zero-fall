extends CanvasLayer
class_name MainMenu

func _on_button_play_pressed():
	GameManager.append_scene("game_level")
	
func _on_button_settings_pressed():
	GameManager.append_scene("settings_menu")

func _on_button_quit_pressed():
	get_tree().quit()
