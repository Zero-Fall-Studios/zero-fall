class_name State
extends Node

@export var animation_name: String
@export var audio_player : AudioStreamPlayer

var gravity: int = ProjectSettings.get_setting("physics/2d/default_gravity")

var parent : Character
var state_machine : StateMachine

signal state_enter
signal state_exit

func enter() -> void:
	state_enter.emit()
	parent.animation_player.play(animation_name)
	if audio_player != null:
		audio_player.play()

func exit() -> void:
	state_exit.emit()

func process_input(_event: InputEvent) -> State:
	return null

func process_frame(_delta: float) -> State:
	return null
	
func process_physics(_delta: float) -> State:
	return null
