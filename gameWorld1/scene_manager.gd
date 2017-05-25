extends Node

var LEFT_EDGE = 8
var RIGHT_EDGE = 312
var DOWN_EDGE = 184
var UP_EDGE = 8

#trying to prevent double transfers
#will do so by adding a 'last transferred' time and make sure that the difference is non tiny
var time_of_last_transfer = 0
var MIN_TIME = 50 # in milliseconds

#checks if "Game" is current scene, opposed to maybe a pause or something
func is_game():
	return "Game" == get_tree().get_current_scene().get_name()

# returns true if current time and time of last transfer are very near
func too_soon():
	return OS.get_ticks_msec() - time_of_last_transfer < MIN_TIME
	

# intiates transfer to another mapTile
func transfer(level, directionGoing, curPos):
	# check if this is all happening inside of the game scene
	if(is_game()):
		# check to make sure that a double transfer isnt being attempted 
		if(!too_soon()):
			time_of_last_transfer = OS.get_ticks_msec()
			var current_mapTile = get_tree().get_nodes_in_group("mapTile")[0]
			var wr = weakref(current_mapTile)
			var target_pos = make_transfer_target(directionGoing, curPos)
			call_deferred("do_transfer", wr, level, target_pos)

func make_transfer_target(directionGoing, curPos):
	if(directionGoing == "RIGHT"):
		return Vector2(LEFT_EDGE, curPos.y)
	elif(directionGoing == "LEFT"):
		return Vector2(RIGHT_EDGE, curPos.y)
	elif(directionGoing == "UP"):
		return Vector2(curPos.x, DOWN_EDGE)
	elif(directionGoing == "DOWN"):
		return Vector2(curPos.x, UP_EDGE)

func do_transfer(wr, level, target_pos):
	move_player(target_pos)	
	free_referenced(wr)
	
	var new_level = ResourceLoader.load(level).instance()
	var game = get_tree().get_current_scene()
	
	new_level.add_to_group("mapTile")
	game.add_child(new_level)
	#game.set_camera_limits(new_level.map_size)
	

func move_player(target_pos):
	for body in get_tree().get_nodes_in_group("player"):
		body.set_global_pos(target_pos)
		break

# if the weak reference references something alive (the current level) it frees it
func free_referenced(wr):
	if(!wr.get_ref()):
		print("transfered/warped with an issue") #this shouldnt get triggered
	else:
		wr.get_ref().free()

# initiates warp to another level
func warp(level, warp):
	if(is_game()):
		var current_level = get_tree().get_nodes_in_group("area")[0]
		var wr = weakref(current_level)
		call_deferred("do_warp", wr, level, warp)

# warps to another level
func do_warp(wr, level, warp):
	free_referenced(wr)

	var new_level = ResourceLoader.load(level).instance()
	var game = get_tree().get_current_scene()
	
	new_level.add_to_group("area")
	game.add_child(new_level)
	#game.set_camera_limits(new_level.map_size)
	
	var target = new_level.find_node(warp)
	if(target extends Position2D):
		move_player(target.get_pos())
	
	print("warped?")