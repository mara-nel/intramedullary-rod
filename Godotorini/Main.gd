extends Node

var MAX_HEIGHT = 4
var PLAYERS_PER_TEAM = 2

var PLACE_PLAYERS = 0
var MAIN_PLAY = 1

var TEAM_ONE = 'team_one'
var TEAM_TWO = 'team_two'

var recorded_moves

var player
var Board
var cell

#var board_coords


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
	recorded_moves = []

func _process(delta):
	# Called every frame. Delta is time since last frame.
	# Update game logic here.
	pass

func _input(event):
	if event is InputEventMouseButton:
		click = change_click()#mouseClickPos = event.positiona
		#print("Mouse Click/Unclick at: ", event.position)
		var board_coords = Board.world_to_map(event.position)
		#print(" which is in tile: ", board_coords)
		if click:
			if state == PLACE_PLAYERS:
				place_players(board_coords)
			elif state == MAIN_PLAY:
				main_play(board_coords)
	#eventually want some sort of restart button
	elif event is InputEventKey:
		if Input.is_key_pressed(KEY_R):
			reset_game()
		elif Input.is_key_pressed(KEY_P):
			#print_player_locations()
			print_recorded_moves()
			#print_last_recorded_move()
		elif Input.is_key_pressed(KEY_M):
			print_matrix()
		elif Input.is_key_pressed(KEY_U):
			undo_last_move()

#function for managing the stage of the game where players put down
# player tokens
func place_players(clicked_coord):
	var number_of_players = get_node("Players").get_child_count()
	if number_of_players < PLAYERS_PER_TEAM:
		add_player(TEAM_ONE,clicked_coord)
		print(get_node("Players").get_child_count())
	elif number_of_players < 2*PLAYERS_PER_TEAM-1:
		add_player(TEAM_TWO,clicked_coord)
		print(get_node("Players").get_child_count())
	else:
		if add_player(TEAM_TWO,clicked_coord):
			state = MAIN_PLAY
			print('state is: ',state)
			record_move(Vector2(-1,-1))
		print(get_node("Players").get_child_count())
	#print_matrix()

# handles the gameplay of the actual game
# turns alternate between players, a turn consists of:
#  -choosing a token
#  -moving that token to an unoccupied adjacent square
#  -building on an unoccupied square adjacent to the moved token
func main_play(clicked_coord):
	if !player_selected:
		select_player(clicked_coord)
		print('trying to select')
	elif player.is_ready_to_move():
		try_to_move(player, clicked_coord)
		print('trying to move')
	elif player.is_ready_to_build():
		var player_board_position = Board.world_to_map(player.get_position())
		try_to_build(clicked_coord, player_board_position)
		print('trying to build')

# resets the game, clears board
func reset_game():
	click = false
	initialize_board_matrix()
	state = PLACE_PLAYERS
	players_turn = TEAM_ONE
	no_player_is_selected()
	clear_buildings()
	clear_players()
	recorded_moves = []

func clear_buildings():
	for node in get_tree().get_nodes_in_group("building"):
		node.queue_free()
func clear_players():
	for node in get_node("Players").get_children():
		node.queue_free()

#mostly for testing purposes
func print_player_locations():
	for node in get_node("Players").get_children():
		print(coord_to_board_coord(node.get_position()))
func print_last_recorded_move():
	print(recorded_moves[-1])



func print_recorded_moves():
	for x in recorded_moves:
		print(x)

func record_move(coord_of_last_build):
	var last_move = []
	for node in get_node("Players").get_children():
		last_move.append( coord_to_board_coord(node.get_position()) )
	last_move.append( coord_of_last_build )
	recorded_moves.append(last_move)

#hit once should revert to last recorded move
#hit twice should remove last move and revert to new last recorded 
func undo_last_move():
	#if a player is selected, then in middle of a turn, revert to its start
	var last_move = recorded_moves[-1]
	var counter
	if player_selected:
		#nothing will be built yet, so don't need to worry about removing a building
		counter = 0
		for node in get_node("Players").get_children():
			var old_pos = Board.map_to_world(last_move[counter])
			node.set_position(old_pos)
			counter +=1
		no_player_is_selected()
	#pop off last recorded and set everything to the last
	elif recorded_moves.size() >= 2:
		var height_of_last_built = get_build_height(last_move[-1])
		remove_last_building_of_height(height_of_last_built)
		undo_board_matrix(last_move[-1])
		recorded_moves.pop_back()
		last_move = recorded_moves[-1]
		counter = 0
		for node in get_node("Players").get_children():
			var old_pos = Board.map_to_world(last_move[counter])
			node.set_position(old_pos)
			counter +=1
		no_player_is_selected()
		switch_turns()
		
func remove_last_building_of_height(given_height):
	var level_dict = {1:"Level_1", 2:"Level_2", 3:"Level_3", 4:"Caps"}
#	if given_height == 1:
#		level = "Level_1"
#	elif given_height == 2:
#		level = "Level_2"
#	elif
	get_node(level_dict[given_height]).get_children()[-1].queue_free()




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
	return !is_occupied
	

func try_to_move(player, board_coord):
	var player_board_coord = coord_to_board_coord(player.get_position())
	var current_height = get_build_height(player_board_coord)
	var move_to_height = get_build_height(board_coord)
	var space_occupied = is_occupied_by_player(board_coord)
	
	#iterate through all player tokens
	#space_occupied = is_occupied_by_player(board_coord)

	if !are_neighbors(board_coord,player_board_coord):
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
		end_turn(square_to_build_in)
		#no_player_is_selected()

# function to handle all the things that should happen when a players 
#  turn ends
func end_turn(coord_of_last_build):
	record_move(coord_of_last_build)
	no_player_is_selected()
	switch_turns()
	

func build_floor(square_to_build_in):
	var current_level = get_build_height(square_to_build_in)
	var scene = load("res://Building.tscn")
	var scene_instance = scene.instance()
	scene_instance.set_name("new_floor")
	var to_build_coords = Board.map_to_world(square_to_build_in)
	scene_instance.set_position(to_build_coords)
	
	if current_level == 0:
		scene_instance.get_node("Sprite").set_texture(load("res://b1.png"))
		get_node("Level_1").add_child(scene_instance)
	elif current_level == 1:
		scene_instance.get_node("Sprite").set_texture(load("res://floor_2.png"))
		get_node("Level_2").add_child(scene_instance)
	elif current_level == 2:
		scene_instance.get_node("Sprite").set_texture(load("res://floor_3.png"))
		get_node("Level_3").add_child(scene_instance)
	elif current_level == 3:
		scene_instance.get_node("Sprite").set_texture(load("res://cap.png"))
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
	
func undo_board_matrix(board_coord):
	var coord_x = board_coord[0]
	var coord_y = board_coord[1]
	board_matrix[coord_y][coord_x] -= 1

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

