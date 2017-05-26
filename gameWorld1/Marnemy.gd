extends KinematicBody2D

var walkSpeed = 30

var nav = null
var velocity = Vector2()
var direction = Vector2()
var timeOfLastDirectionChange = 0
var minDirectionChangeTime = 3


# set true if a navigation2d exists and you want to move around in it
export (bool) var mobile = true


var NORTH = Vector2(0,-1)
var SOUTH = Vector2(0,1)
var WEST = Vector2(-1,0)
var EAST = Vector2(1,0)
var DIRECTIONS = [ NORTH, SOUTH, WEST, EAST ]



func _ready():
	set_fixed_process(true)
#	DIRECTIONS.append(NORTH)
#	DIRECTIONS.append(SOUTH)
#	DIRECTIONS.append(WEST)
#	DIRECTIONS.append(EAST)
	direction = DIRECTIONS[randi()%4]
	directionChanged()

#func _on_Enemy_body_enter(body):
#	if(body.is_in_group("weapon")):
#		print("hit by a weapon")
		
	
func _fixed_process(delta):
	if(is_colliding() and get_collider().is_in_group("weapon")):
		self.queue_free()
		print("gone")
	
	#follows a path
	if(get_parent().get_type() == "PathFollow2D"):
		get_parent().set_offset(get_parent().get_offset() + (walkSpeed*delta))
	
	#wanders around in the nav
	elif(mobile):
		if(nav == null):
			#get the navigation2d which will be a child off of the root
			# better hope the guy is a child of a child of whatever has the nav
			nav = get_parent().get_parent().get_node("Navigation2D")
		if(nav != null): # fails when no such navigation2d node is found
			# turns around if it hits something
			if(is_colliding()):
				direction = getNewDirection()
				print(get_collider().get_name())
			elif(OS.get_unix_time()- timeOfLastDirectionChange > minDirectionChangeTime):
				direction = getNewDirection()
			velocity = direction*walkSpeed*delta
			
#			if(Input.is_action_pressed("ui_accept")):
#				print(str(velocity.x)+ " " + str(velocity.y))
			
			if(canMove()):
				move(velocity)
			else:
				direction = getNewDirection()
	
	#hides if collides with a weapon
#	if(is_colliding()):
#		var hitting = get_collider()
#		if(!hitting.get_name() == "TileMap"):
#			print("  "+get_name() + " hit " + hitting.get_name())

	
		#hide()
	
# returns true if the moving in the current direction stays in the mesh
func canMove():
	var attemptedMove = get_pos()+velocity
	var closestToAttempt  = nav.get_closest_point(attemptedMove)
	#return attemptedMove == nav.get_closest_point(attemptedMove)
	#print(str(attemptedMove.x) + " " + str(attemptedMove.y))
	#print(str( closestToAttempt.x) + " " + str( closestToAttempt.y))
	return attemptedMove ==  closestToAttempt
	

func getNewDirection():
	var newD = DIRECTIONS[randi()%4]
	while( newD == direction):
		newD = DIRECTIONS[randi()%4]
	directionChanged()
	return newD

#updates the things that need to change when direction changes
func directionChanged():
	timeOfLastDirectionChange = OS.get_unix_time()
	minDirectionChangeTime = randi()%4+1

# determines a random point in the mapTile
func randomGamePoint():
	var xCoord = randi()%320
	var yCoord = randi()%192
	return Vector2(xCoord, yCoord)