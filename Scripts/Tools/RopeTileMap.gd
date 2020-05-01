extends TileMap

const ROPE_TILE_NAME = "Rope"

onready var rope = preload("res://Scenes/Objects/RopeCheckpoint.tscn")

onready var ui = get_parent().get_parent().find_node("UILayer")

func _ready():
	var height = null
	var tiles = []
	for tile in get_used_cells():
		var name = get_tileset().tile_get_name(get_cell(tile.x, tile.y))
		if name == ROPE_TILE_NAME:
			if height != null and tile.y != height:
				add_new_checkpoint(tiles, height)
				tiles = []
			tiles.append(tile)
			height = tile.y

	if len(tiles) > 0:
		add_new_checkpoint(tiles, height)

func add_new_checkpoint(tiles, height):
	var new_rope = rope.instance()
	new_rope.position = map_to_world(tiles[len(tiles) / 2]) + cell_size / 2
	new_rope.connect("advanced_level", ui, "_on_advanced_level")
	add_child(new_rope)
