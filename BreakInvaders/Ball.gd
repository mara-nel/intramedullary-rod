extends KinematicBody2D

var velocity = Vector2(0.5,-1)
var moveSpeed = 125

var startPos = Vector2(160,330)
#these are dependent on window size, so some better way of 
# passing that information on should be used rather than just 
# redefining them here
var leftBound = 0
var rightBound = 300
var upBound = 0
var downBound = 512

signal outOfBounds

func _ready():
	set_fixed_process(true)
	set_process_input(true)

func reset():
	set_pos(startPos)
	velocity = Vector2(-.3,-1)

func _fixed_process(delta):
	var movingTo = get_pos() + velocity*delta
#	if(movingTo.x > rightBound):
#		velocity.x = -velocity.x
#	elif(movingTo.x < leftBound):
#		velocity.x = -velocity.x
#	if(movingTo.y < upBound):
#		velocity.y = -velocity.y
#	elif(movingTo.y > downBound):
#		emit_signal("outOfBounds")
	
	if(is_colliding()):
		velocity = get_collision_normal()
		var coll = get_collider()
		if(coll.is_in_group("brick")):
			coll.wasHit()

	#some slight gravity
	#velocity.y += .001

	move(velocity*moveSpeed*delta)

# for testing purposes
#func _input(event):
#	if(Input.is_action_pressed("ui_accept")):
#		print(str(velocity))


			