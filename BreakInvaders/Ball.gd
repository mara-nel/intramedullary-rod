extends KinematicBody2D

var velocity 
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
	
	var x = randi()%16-8
	if(x==0):
		x+=1
	var y = randi()%16-16
	velocity = Vector2(x,y).normalized()
	
	set_fixed_process(true)
	set_process_input(true)

#func reset():
#	set_pos(startPos)
#	velocity = Vector2(-.3,-1)

func _fixed_process(delta):
	var movingTo = get_pos() + velocity*delta
	
	if(is_colliding()):
		#print(str(rad2deg(velocity.angle())))
		bounce(get_collision_normal())
		#velocity = get_collision_normal()
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


# trying to code my own bounce method for the ball, is tricky
# might try and see godots way of doing it for rigidbodies (dont like rigidbodies because
# they dont have an iscolliding method which is how I get bricks to drop and its a little
# overkill for what I need)
func bounce(collisionNormal):
	#velocity = collisionNormal.slide(velocity)
	#velocity = -velocity.reflect(collisionNormal)	
	var angle = velocity.angle()
	var newAngle 
	var collAngle = collisionNormal.angle()
	if(abs(collAngle)-PI/2<1 and abs(collAngle)-PI/2>-1):
		newAngle = -angle
	else:
		newAngle = PI - angle
	velocity = Vector2(0,1).rotated(newAngle)
	#velocity = rad2vec(newAngle)
	
	
	