extends Node

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

var player
var Board
var cell

var boardCoords
var ctrCoords

var click





func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	player = get_node("Player1")
	Board = get_node("Board")
	#tiles = Board.get_tileset()
	player.set_state_move()
	click = false
	

func _process(delta):
	# Called every frame. Delta is time since last frame.
	# Update game logic here.
	pass

func _input(event):
	if event is InputEventMouseButton:
		click = change_click()#mouseClickPos = event.positiona
		print("Mouse Click/Unclick at: ", event.position)
		boardCoords = Board.world_to_map(event.position)
		print(" which is in tile: ", boardCoords)
		ctrCoords = Board.map_to_world(Board.world_to_map(event.position))
		print(" with center coord: ", ctrCoords)
		if click:
			if player.is_ready_to_move():
				player.move(ctrCoords)
				player.set_state_build()
			elif player.is_ready_to_build() and ctrCoords != player.get_position():
				build_floor(ctrCoords)

func change_click():
	return !click

func build_floor(ctrCoords):
	var scene = load("res://BottomFloor.tscn")
	var scene_instance = scene.instance()
	scene_instance.set_name("newFloor")
	scene_instance.set_position(ctrCoords)
	get_node("Floors").add_child(scene_instance)
	#add_child(scene_instance)
	player.set_state_move()
