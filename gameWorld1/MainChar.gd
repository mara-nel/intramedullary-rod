extends KinematicBody2D

var velocity = Vector2()
var walkSpeed = 75
var runSpeed = 100

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	set_fixed_process(true)
	set_process_input(true)

func _input(event):
	if(Input.is_action_pressed("ui_select")):
		print(str(get_pos().x) +" "+str(get_pos().y))
	
func _fixed_process(delta):
	velocity = Vector2()
	var moveSpeed = walkSpeed
	#if(Input.is_action_just_pressed("ui_select")):
	#	print(str(get_pos().x) +" "+str(get_pos().y))
	
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
		# good for testing whats being collided with
		#print(get_collider().get_name())
		var n = get_collision_normal()
		motion = n.slide(motion)
		velocity = n.slide(velocity)
		move(motion)
