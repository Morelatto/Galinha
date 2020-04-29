extends Node2D

var world_list = []
var loaded_worlds = []

onready var chicken = find_node("Chicken")

export var number_of_worlds = 3
var world_index = 0

func _ready():
	load_world_list()
	load_next_world()
	load_next_world()
	pass

func load_next_world():
	if world_index > number_of_worlds - 1:
		#load last level
		return
	var world = world_list[world_index].instance()
	world_index += 1
	if loaded_worlds.size() >= 1:
		var last_world = loaded_worlds[loaded_worlds.size() - 1]
		var bottom_of_map = world.get_node("LevelBottom")
		world.position.y = last_world.position.y - bottom_of_map.position.y
	else:
		world.position.y = -world.get_node("LevelBottom").position.y

	loaded_worlds.push_back(world)
	add_child(world)

	if loaded_worlds.size() > 3:
		var deleteWorld = loaded_worlds[0]
		remove_child(deleteWorld)

		loaded_worlds.pop_front()
		call_deferred("free")



func load_world_list():
	for i in range(number_of_worlds):
		var world = load("res://Scenes/Stages/World_" + str(i) + ".tscn")
		world_list.append(world)
