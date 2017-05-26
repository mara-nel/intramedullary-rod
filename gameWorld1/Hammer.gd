extends KinematicBody2D


var upColliderLive
var downColliderLive
var leftColliderLive
var rightColliderLive

var DOWN = 0
var LEFT = 1
var UP = 3
var RIGHT = 2

var sprite

var directionFacing = DOWN

var directionColliderDict = { UP:"UpCollision", DOWN: "DownCollision", LEFT: "LeftCollision", RIGHT:"RightCollision"}


func _ready():
	sprite = get_node("Sprite")
	set_fixed_process(true)

func _fixed_process(delta):
	if(is_hidden()):
		turnOffColliders()

#sets the sprite frame to face correct direction and turns on corresponding collider
func change_direction(direction):
	turnOffColliders()
	sprite.set_frame(direction)
	if direction in directionColliderDict:
		get_node(directionColliderDict[direction]).set_trigger(false)
#	if(direction == UP):
#		get_node("UpCollsion").set_trigger(false)
#	elif(direction == DOWN):
#		get_node("DownCollsion").set_trigger(false)
#	elif(direction == LEFT):
#		get_node("LeftCollsion").set_trigger(false)
#	elif(direction == RIGHT):
#		get_node("RightCollision").set_trigger(false)
	
	
func turnOffColliders():
	for child in get_children():
		if (child.get_type() == "CollisionPolygon2D"):
			child.set_trigger(true) #turns it off