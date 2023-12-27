extends Node

@export var playlist: Array[AudioStreamPlayer]

func _ready():
	print("playlist 2", playlist)

func play(song_name: String):
	print("playlist", playlist)
	for song in playlist:
		print(song)
		if song.name == song_name:
			song.play()
			return
	print("Song not found")