extends KinematicBody2D

var walkSpeed = 30

# vars used for randomWalk()
var atDest = true
var target = Vector2()
var path = null
var nav = null

# set true if a navigation2d exists and you want to move around in it
export (bool) var mobile = true


var NORTH = Vector2(0,-1)
var SOUTH = Vector2(0,1)
var WEST = Vector2(-1,0)
var EAST = Vector2(1,0)


func _ready():
	set_fixed_process(true)

func _fixed_process(delta):
	if(get_parent().get_type() == "PathFollow2D"):
		get_parent().set_offset(get_parent().get_offset() + (walkSpeed*delta))
	
	elif(mobile):
		if(nav == null):
			nav = get_parent().get_parent()
			print(nav.get_type())
		#randomWalk(nav)
		#get the navigation2d which will be a child off of the root
		#var target = nav.get_closest_point(randomGamePoint())
		#path = nav.get_simple_path(get_pos(), target)
		

# performs a random walk and creates a new one to follow after reaching destination
func randomWalk():

		if( atDest == true):
			target = nav.get_closest_point(randomGamePoint())

			path = nav.get_simple_path(get_pos(), target)
			pass

# determines a random point in the mapTile
func randomGamePoint():
	var xCoord = randi()%320
	var yCoord = randi()%192
	return Vector2(xCoord, yCoord)