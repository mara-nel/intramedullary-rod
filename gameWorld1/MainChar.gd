extends KinematicBody2D

var NORTH = Vector2(0,-1)
var SOUTH = Vector2(0,1)
var WEST = Vector2(-1,0)
var EAST = Vector2(1,0)

var velocity = Vector2()
var walkSpeed = 125
var runSpeed = 100
var direction = SOUTH

var health

# these are specifically defined for current sprite sheet
# ie this is probably a bad way to do things/will be updated later
var DOWN = 0
var LEFT = 1
var UP = 3
var RIGHT = 2



var directionDict = { NORTH: UP, SOUTH: DOWN, WEST:LEFT, EAST: RIGHT }

#used to keep track of which direction was most recently pressed
var lastPressed = SOUTH


var sprite
var weapon
var healthBar


func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	set_fixed_process(true)
	set_process_input(true)
	sprite = get_node("Sprite")
	weapon = get_node("Hammer")
	healthBar = get_parent().get_node("HealthBar")
	
	health = 100

# for things that happen, not a constantly running thing?
func _input(event):
	if(event.is_action_pressed("ui_select") and not event.is_echo()):
		print(str(get_pos()))
	if(event.is_action("left_click")):
		set_pos(get_viewport().get_mouse_pos())
	
	if(event.is_action_pressed("ui_down") and not event.is_echo()):
		lastPressed = SOUTH
	elif(event.is_action_pressed("ui_left") and not event.is_echo()):
		lastPressed = WEST
	elif(event.is_action_pressed("ui_right") and not event.is_echo()):
		lastPressed = EAST
	elif(event.is_action_pressed("ui_up") and not event.is_echo()):
		lastPressed = NORTH


# a more constantly running thing, for continuous operations
func _fixed_process(delta):
	velocity = Vector2()
	weapon.hide()
	if(Input.is_action_pressed("ui_accept")):
		weapon.unSheath(directionDict[direction])
	
	var numbPresses = numberOfDirectionsPressed()
	if(numbPresses > 1):
		set_direction(lastPressed)
	else:
		if(Input.is_action_pressed("ui_down")):
			set_direction(SOUTH)
		elif(Input.is_action_pressed("ui_up")):
			set_direction(NORTH)
		elif(Input.is_action_pressed("ui_left")):
			set_direction(WEST)
		elif(Input.is_action_pressed("ui_right")):
			set_direction(EAST)
	
	#sets velocity only if some direction is currently pressed
	if(numbPresses > 0):
		set_velocity()
	var motion = velocity * delta
	move(motion)
	
	if(weapon.is_colliding()):
		print("weapon is colliding")
	
	
	#provides a slide feature for movement along a wall
	if(is_colliding()):
		# good for testing whats being collided with
		print(get_collider().get_name())
		print("collision at: "+str(get_pos()))
		
		if(get_collider().is_in_group("enemy")):
			health -= 20
			healthBar.set_health(health)
			
	
		var n = get_collision_normal()
		motion = n.slide(motion)
		velocity = n.slide(velocity)
		move(motion)
	if(weapon.is_colliding()):
		print("*hammer has hit: " + get_collider().get_name())
		

func set_direction(dir):
	direction = dir
	sprite.set_frame(directionDict[direction])
	weapon.change_direction(directionDict[direction])
	weapon.set_pos(10*direction)
	
func set_velocity():
	velocity = direction * walkSpeed
	
func numberOfDirectionsPressed():
	var num = 0
	for dir in ["ui_down", "ui_up", "ui_left", "ui_right"]:
		if(Input.is_action_pressed(dir)):
			num +=1
	return num
