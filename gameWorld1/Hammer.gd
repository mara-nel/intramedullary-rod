extends KinematicBody2D


var upColliderLive
var downColliderLive
var leftColliderLive
var rightColliderLive

var DOWN = 0
var LEFT = 1
var UP = 3
var RIGHT = 2

onready var sprite = get_node("Sprite")

var directionFacing = DOWN

var directionColliderDict = { UP:"UpCollision", DOWN: "DownCollision", LEFT: "LeftCollision", RIGHT:"RightCollision"}


func _ready():
	turnOffColliders()
	set_fixed_process(true)

func _fixed_process(delta):
	if(is_hidden()):
		turnOffColliders()
	if(is_colliding()):
		print("hammer has hit: " + get_collider().get_name())

#sets the sprite frame to face correct direction and turns on corresponding collider
func change_direction(direction):
	turnOffColliders()
	sprite.set_frame(direction)
	if direction in directionColliderDict:
		get_node(directionColliderDict[direction]).set_trigger(false)
	
	
func turnOffColliders():
	for child in get_children():
		if (child.get_type() == "CollisionPolygon2D"):
			child.set_trigger(true) #turns it off
			
func unSheath(direction):
	show()
	change_direction(direction)
		