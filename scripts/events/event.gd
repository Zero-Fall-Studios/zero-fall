class_name Event
extends Node

@export var event_name : String
@export var time_to_wait_after : float = 0.0

func run():
  print("Event: " + event_name)
  await get_tree().create_timer(time_to_wait_after).timeout
