extends Node2D

export(Array, PackedScene) var levels

onready var chicken = $Chicken

func _ready():
	var stages = Node2D.new()
	var height = 0
	for level in levels:
		level = level.instance()
		height += get_level_height(level)
		level.position.y = -height
		stages.add_child(level)
		check_for_spawner(level)
		Globals.total_eggs += has_egg(level)
	add_child(stages)

func get_level_height(level):
	var tilemap = level.find_node("RockTileMap")
	var used_rect = tilemap.get_used_rect().end
	return tilemap.map_to_world(used_rect).y

func check_for_spawner(level):
	var spawner = level.find_node("Spawner")
	if spawner != null:
		var spawner_pos = spawner.get_position()
		var spawner_transform = spawner.get_transform()
		spawner_pos.y += level.position.y
		chicken.position = spawner_pos
		spawner_transform.origin = spawner_pos
		chicken.checkpoint = spawner_transform

func has_egg(level):
	return 1 if level.find_node("Egg") != null else 0
