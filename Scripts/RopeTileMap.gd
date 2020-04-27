extends TileMap

const ROPE_TILE_NAME = "Rope"

func _ready():
	var height = null
	var tiles = []
	for tile in get_used_cells():
		var name = get_tileset().tile_get_name(get_cell(tile.x, tile.y))
		if name == ROPE_TILE_NAME:
			if height != null and tile.y != height:
				add_new_area_2d(tiles, height)
				tiles = []
			tiles.append(tile)
			height = tile.y

	if len(tiles) > 0:
		add_new_area_2d(tiles, height)

func add_new_area_2d(tiles, height):
	var body = StaticBody2D.new()
	var cs = CollisionShape2D.new()
	cs.shape = SegmentShape2D.new()
	cs.shape.b = Vector2(cell_size.x * len(tiles), 0)
	cs.position = map_to_world(tiles[0], true)
	cs.one_way_collision = true
	body.add_child(cs)
	add_child(body)
