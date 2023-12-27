class_name EventAudio
extends Event

@export var song_name : String

var events : Array[Event]

func run():
  GameAudio.play(song_name)

