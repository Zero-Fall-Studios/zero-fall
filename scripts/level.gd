class_name Level
extends Node

@export var player : Character

var spawn_points

func _ready():  
	spawn_points = get_tree().get_nodes_in_group("spawn_point")
	player.spawn(spawn_points[0].position)
	
	var npcs = get_tree().get_nodes_in_group("npc")
	for npc in npcs:
		npc.spawn(npc.position)
