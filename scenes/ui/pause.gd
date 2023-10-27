extends CanvasLayer
class_name Pause

@onready var button_quit : Button = $MarginContainer/Panel/CenterContainer/VBoxContainer/ButtonQuit

func _ready():
	button_quit.grab_focus()
	hide()

func _input(event):
	if event.is_action_pressed("cancel"):
		set_visible(!get_tree().paused)
		button_quit.grab_focus()
		get_tree().paused = !get_tree().paused


func _on_button_quit_pressed():
	get_tree().quit()


func _on_button_settings_pressed():
	print("Show setting")
	pass # Replace with function body.
