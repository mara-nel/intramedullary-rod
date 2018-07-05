extends Node

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

var player
var Board
var cell

var board_coords
var ctr_coords

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
		board_coords = Board.world_to_map(event.position)
		print(" which is in tile: ", board_coords)
		ctr_coords = Board.map_to_world(Board.world_to_map(event.position))
		print(" with center coord: ", ctr_coords)
		if click:
			#in future there might be multiple player nodes, so a player select
			# would be made, in that step player position could get recorded as
			# it is done here
			var player_board_position = Board.world_to_map(player.get_position())
			if player.is_ready_to_move() and are_neighbors(board_coords,player_board_position):
				player.move(ctr_coords)
				player.set_state_build()
			elif player.is_ready_to_build() and ctr_coords != player.get_position():
				if are_neighbors(board_coords, player_board_position):
					build_floor(ctr_coords)

func change_click():
	return !click

func build_floor(ctr_coords):
	var scene = load("res://BottomFloor.tscn")
	var scene_instance = scene.instance()
	scene_instance.set_name("newFloor")
	scene_instance.set_position(ctr_coords)
	get_node("Floors").add_child(scene_instance)
	#add_child(scene_instance)
	player.set_state_move()

#the game takes place on a grid, the below returns true if the two points
# are for grid points that are neighbors (including diagonals)
func are_neighbors(board_cell_1, board_cell_2):
	var x_difference = abs(board_cell_1.x - board_cell_2.x)
	var y_difference = abs(board_cell_1.y - board_cell_2.y)
	if x_difference <= 1 and y_difference <=1:
		return true
	else:
		return false
