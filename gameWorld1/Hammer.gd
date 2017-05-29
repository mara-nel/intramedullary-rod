extends KinematicBody2D


var upColliderLive
var downColliderLive
var leftColliderLive
var rightColliderLive

var DOWN = 3
var LEFT = 2
var UP = 0
var RIGHT = 1

onready var sprite = get_node("Sprite")
onready var colliders = get_tree().get_nodes_in_group("collider")
var directionFacing = DOWN

var directionColliderDict = { UP:"UpCollision", DOWN: "DownCollision", LEFT: "LeftCollision", RIGHT:"RightCollision"}
var isCharged = false
var isSheathed = true

func _ready():
	sheath()
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
	for coll in colliders:
		coll.set_trigger(true)

func sheath():
	isSheathed = true
	hide()

	

func unSheath(direction):
	isSheathed = false
	show()
	change_direction(direction)
		