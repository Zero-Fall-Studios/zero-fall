class_name EventSystem
extends Node

@export var run_events_on_ready : bool = false

var events : Array[Event]

func _ready():
  for child in get_children():
    if child is Event:
      events.append(child)
  if run_events_on_ready:
    run_events()

func run_events():
  for event in events:
    print("Running event: " + event.event_name)
    await event.run()

