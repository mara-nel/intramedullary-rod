extends Node

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

var player
var Board
var cell

var boardCoords
var ctrCoords




func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	player = get_node("Player1")
	Board = get_node("Board")
	#tiles = Board.get_tileset()
	
	

func _process(delta):
	# Called every frame. Delta is time since last frame.
	# Update game logic here.
	pass

func _input(event):
	if event is InputEventMouseButton:
		#mouseClickPos = event.positiona
		print("Mouse Click/Unclick at: ", event.position)
		boardCoords = Board.world_to_map(event.position)
		print(" which is in tile: ", boardCoords)
		ctrCoords = Board.map_to_world(Board.world_to_map(event.position))
		print(" with center coord: ", ctrCoords)
		player.move(ctrCoords)
