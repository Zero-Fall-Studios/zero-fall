extends Node2D

@onready var main_menu : MainMenu = $MainMenu
@onready var pause_menu : Pause = $Pause
@onready var settings_menu : SettingsMenu = $SettingsMenu

var game_level = load("res://scenes/levels/level1.tscn")

func _ready():
	print("Game ready ...")
	GameManager.add_scene("main_menu", main_menu)
	GameManager.add_scene("pause_menu", pause_menu)
	GameManager.add_scene("settings_menu", settings_menu)
	GameManager.add_scene("game_level", game_level)
