extends TileMap

const ROPE_TILE_NAME = "Rope"
const ROPE = preload("res://Scenes/Rope.tscn")


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
	var rope = ROPE.instance()
	rope.position = map_to_world(tiles[((len(tiles))/2)])+cell_size/2
	add_child(rope)
