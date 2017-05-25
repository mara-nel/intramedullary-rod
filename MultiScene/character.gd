extends KinematicBody2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

var velocity = Vector2()
var walkSpeed = 50
var runSpeed = 100

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	set_fixed_process(true)

func _fixed_process(delta):
	velocity = Vector2()
	var moveSpeed = walkSpeed
	if(Input.is_action_pressed("ui_select")):
		moveSpeed = runSpeed
	
	if(Input.is_action_pressed("ui_down")):
		velocity.y = moveSpeed
	elif(Input.is_action_pressed("ui_up")):
		velocity.y = -moveSpeed
	if(Input.is_action_pressed("ui_left")):
		velocity.x = -moveSpeed
	elif(Input.is_action_pressed("ui_right")):
		velocity.x = moveSpeed
	var motion = velocity * delta
	move(motion)
	
	#provides a slide feature for movement along a wall
	if(is_colliding()):
		var n = get_collision_normal()
		motion = n.slide(motion)
		velocity = n.slide(velocity)
		move(motion)
