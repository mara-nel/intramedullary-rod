extends Node

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
var MAX_HEIGHT = 4
var PLAYERS_PER_TEAM = 2

var PLACE_PLAYERS = 0
var MAIN_PLAY = 1

var TEAM_ONE = 'team_one'
var TEAM_TWO = 'team_two'


var player
var Board
var cell

var board_coords
var click_ctr_coords

var click
var players_turn

var board_matrix
var state
var player_selected


func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	#player = get_node("Players/Player1")
	Board = get_node("Board")
	#tiles = Board.get_tileset()
	#player.set_state_move()
	click = false
	initialize_board_matrix()
	state = PLACE_PLAYERS
	players_turn = TEAM_ONE
	no_player_is_selected()

func _process(delta):
	# Called every frame. Delta is time since last frame.
	# Update game logic here.
	pass

func _input(event):
	if event is InputEventMouseButton:
		click = change_click()#mouseClickPos = event.positiona
		#print("Mouse Click/Unclick at: ", event.position)
		board_coords = Board.world_to_map(event.position)
		#print(" which is in tile: ", board_coords)
		click_ctr_coords = Board.map_to_world(board_coords)
		#print(" with center coord: ", click_ctr_coords)
		if click:
			if state == PLACE_PLAYERS:
				var number_of_players = get_node("Players").get_child_count()
				if number_of_players < PLAYERS_PER_TEAM:
					add_player(TEAM_ONE,board_coords)
					print(get_node("Players").get_child_count())
				elif number_of_players < 2*PLAYERS_PER_TEAM-1:
					add_player(TEAM_TWO,board_coords)
					print(get_node("Players").get_child_count())
				else:
					add_player(TEAM_TWO,board_coords)
					print(get_node("Players").get_child_count())
					state = MAIN_PLAY
					print('state is: ',state)
			elif state == MAIN_PLAY:
				if !player_selected:
					select_player(board_coords)
					print('trying to select')

				elif player.is_ready_to_move():
					try_to_move(player, board_coords)
					print('trying to move')

				elif player.is_ready_to_build():
					var player_board_position = Board.world_to_map(player.get_position())
					try_to_build(board_coords, player_board_position)
					print('trying to build')
				#print_matrix()
	#eventually want some sort of restart button
	#elif event is InputEventKey:
	#	if Input.is_key_pressed(KEY_R):
	#		_ready() #does not do it all, will need to clear things away too

#used to help distinguish between down click and unclick of the mouse
func change_click():
	return !click


func no_player_is_selected():
	player_selected = false
func player_is_selected():
	player_selected = true

#checks if a player is in a given square, if so it makes said player
# the 'selected' player
#can only select play tokens corresponding to the current team
func select_player(selected_square):
	#iterate through all player tokens
	for node in get_node("Players").get_children():
		if selected_square == coord_to_board_coord(node.get_position()):
			if node.is_in_group(players_turn):
				player = node
				player.set_state_move()
				player_is_selected()


#adds a new player token of a given team to a given location
#currently doesn't look at team
func add_player(team, spawn_location):
	var is_occupied = is_occupied_by_player(spawn_location)
	#is_occupied = is_occupied_by_player(spawn_location)
	
	if !is_occupied:
		var scene = load("res://Player.tscn")
		var scene_instance = scene.instance()
		if team == TEAM_ONE:
			scene_instance.add_to_group(TEAM_ONE)
		elif team == TEAM_TWO:
			scene_instance.add_to_group(TEAM_TWO)
			scene_instance.get_node("Sprite").set_texture(load("res://p2.png"))
	
		var to_build_coords = Board.map_to_world(spawn_location)
		scene_instance.set_position(to_build_coords)
	
		get_node("Players").add_child(scene_instance)
	

func try_to_move(player, board_coord):
	var player_board_coord = coord_to_board_coord(player.get_position())
	var current_height = get_build_height(player_board_coord)
	var move_to_height = get_build_height(board_coord)
	var space_occupied = is_occupied_by_player(board_coord)
	
	#iterate through all player tokens
	#space_occupied = is_occupied_by_player(board_coord)

	if !are_neighbors(board_coords,player_board_coord):
		pass
	elif move_to_height - current_height > 1:
		pass
	elif space_occupied:
		pass
	#checks if capped (as of now capped is just a level 4)
	elif move_to_height == 4:
		pass
	else:
		player.move(Board.map_to_world(board_coord))
		if move_to_height == 3:
			print(players_turn, " just won")
		player.set_state_build()

#checks if the selected spot can be built upon ie checks if:
#  space is neighboring selected player
#  no one occupies seleced space
#  not occupied by tallest building
# if everything is met, it builds the next level
func try_to_build(square_to_build_in, selected_player_board_position):
	var space_occupied = is_occupied_by_player(square_to_build_in)
	
	#iterate through all player tokens
	#space_occupied 
	
	#check to see if squares are adjacent
	if !are_neighbors(square_to_build_in, selected_player_board_position):
		pass
	elif space_occupied:
		pass
	#checks if there is still room to build another level onto
	elif is_too_tall(square_to_build_in):
		pass
	else:
		build_floor(square_to_build_in)
		end_turn()
		#no_player_is_selected()

# function to handle all the things that should happen when a players 
#  turn ends
func end_turn():
	no_player_is_selected()
	switch_turns()

func build_floor(square_to_build_in):
	var current_level = get_build_height(square_to_build_in)
	if current_level == 0:
		var scene = load("res://BottomFloor.tscn")
		var scene_instance = scene.instance()
		scene_instance.set_name("new_floor")
		var to_build_coords = Board.map_to_world(square_to_build_in)
		scene_instance.set_position(to_build_coords)
		get_node("Level_1").add_child(scene_instance)
	elif current_level == 1:
		var scene = load("res://Floor_2.tscn")
		var scene_instance = scene.instance()
		scene_instance.set_name("new_floor")
		var to_build_coords = Board.map_to_world(square_to_build_in)
		scene_instance.set_position(to_build_coords)
		get_node("Level_2").add_child(scene_instance)
	elif current_level == 2:
		var scene = load("res://Level_3.tscn")
		var scene_instance = scene.instance()
		scene_instance.set_name("new_floor")
		var to_build_coords = Board.map_to_world(square_to_build_in)
		scene_instance.set_position(to_build_coords)
		get_node("Level_3").add_child(scene_instance)
	elif current_level == 3:
		var scene = load("res://Cap.tscn")
		var scene_instance = scene.instance()
		scene_instance.set_name("new_floor")
		var to_build_coords = Board.map_to_world(square_to_build_in)
		scene_instance.set_position(to_build_coords)
		get_node("Caps").add_child(scene_instance)
	
	
	
	update_board_matrix(square_to_build_in)
	
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

func is_occupied_by_player(board_coord):
	var is_occupied = false
	#iterate through all player tokens
	for node in get_node("Players").get_children():
		if board_coord == coord_to_board_coord(node.get_position()):
			is_occupied = true
	return is_occupied

func switch_turns():
	if players_turn == TEAM_ONE:
		players_turn = TEAM_TWO
	else:
		players_turn = TEAM_ONE



#returns true if a board_coord is too built upon to build once more
func is_too_tall(board_coord):
	var coord_x = board_coord[0]
	var coord_y = board_coord[1]
	if board_matrix[coord_y][coord_x] >= MAX_HEIGHT:
		return true
	else:
		return false

func get_build_height(board_coord):
	var coord_x = board_coord[0]
	var coord_y = board_coord[1]
	return board_matrix[coord_y][coord_x]

func update_board_matrix(board_coord):
	var coord_x = board_coord[0]
	var coord_y = board_coord[1]
	board_matrix[coord_y][coord_x] += 1

func initialize_board_matrix():
	board_matrix = []
	for x in range(5):
		board_matrix.append([])
		for y in range(5):
			board_matrix[x].append(0)

#useful for testing purposes
func print_matrix():
	for row in range(5):
		print(board_matrix[row])
	print('----------')

func coord_to_board_coord(coord):
	return Board.world_to_map(coord)

