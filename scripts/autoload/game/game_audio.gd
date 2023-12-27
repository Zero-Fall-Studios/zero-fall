extends Node

@export var playlist: Array[AudioStreamPlayer]

func play(song_name: String):
	for song in playlist:
		if song.name == song_name:
			song.play()
			return