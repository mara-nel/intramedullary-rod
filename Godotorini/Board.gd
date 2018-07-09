extends TileMap

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
var world_center = Vector2()

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass

func map_to_world(map_position):
	# the idea of this is it returns the center of the tile
	# in world coordinates given the tile's map coordinates
	world_center.x = map_position.x*cell_size.x + cell_size.x/2
	world_center.y = map_position.y*cell_size.y + cell_size.y/2
	
	return world_center