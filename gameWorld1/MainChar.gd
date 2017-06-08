extends KinematicBody2D

var NORTH = Vector2(0,-1)
var SOUTH = Vector2(0,1)
var WEST = Vector2(-1,0)
var EAST = Vector2(1,0)

var velocity = Vector2()
var walkSpeed = 100
var runSpeed = 100
var direction

var health
var maxHealth = 100

# these are specifically defined for current sprite sheet
# ie this is probably a bad way to do things/will be updated later
var DOWN = 3 #0
var LEFT = 2 #1
var UP = 0 #3
var RIGHT = 1 #2

var directionDict = { NORTH: UP, SOUTH: DOWN, WEST:LEFT, EAST: RIGHT }
var directionAsString = { NORTH: "North", SOUTH: "South", EAST:"East", WEST:"West"} 
#used to keep track of which direction was most recently pressed
var lastPressed = SOUTH

onready var sprite = get_node("Sprite")
onready var weapon = get_node("Hammer")
onready var healthBar = get_parent().get_node("HealthBar")
onready var hitTimer = get_node("RecentHitTimer")
onready var animator = get_node("AnimationPlayer")
onready var sEffect = get_node("SwingEffect")

signal move
var is_moving = false


func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	set_fixed_process(true)
	set_process_input(true)
	
	health = maxHealth
	set_direction(SOUTH)
	

# for things that happen, not a constantly running thing?
func _input(event):
	#######
	### useful things for testing
	if(event.is_action_pressed("ui_select") and not event.is_echo()):
		#print(str(get_pos()))
		#print(str(hitTimer.get_time_left()))
		
		weapon.unSheath(directionDict[direction])
		if(direction ==NORTH):
			weapon.set_draw_behind_parent(true)
		else:
			weapon.set_draw_behind_parent(false)
		weapon.isCharged = true
		
	if(event.is_action_pressed("ui_focus_next")):
		addHealth(-20)
		healthBar.set_health(health)
	#######
	if(event.is_action_released("ui_accept")):
		swingHammer()

	
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
	is_moving = false
	velocity = Vector2()
	if(Input.is_action_pressed("ui_accept")):
		#weapon.unSheath(directionDict[direction])
		if(direction ==NORTH):
			weapon.set_draw_behind_parent(true)
		else:
			weapon.set_draw_behind_parent(false)
		
	var numbPresses = numberOfDirectionsPressed()
	if(numbPresses >0):
		is_moving = true
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
		set_velocity()
	var motion = velocity * delta
	move(motion)
	if(is_moving):
		emit_signal("move")
	else:
		if(!animator.is_playing()):
			
			#animator.play("SouthRest")
			pass
	
	if(is_colliding()):
		# good for testing whats being collided with
		#print("char hit: "+get_collider().get_name())
		#print("collision at: "+str(get_pos()))
		
		if(get_collider().is_in_group("enemy")):
			gotHitByEnemy()
	
		#provides a slide feature for movement along a wall
		var n = get_collision_normal()
		motion = n.slide(motion)
		velocity = n.slide(velocity)
		move(motion)
		
	if(weapon.is_colliding()):
		print("*hammer has hit: " + get_collider().get_name())
		

func set_direction(dir):
	if(direction != dir):
		direction = dir
		sprite.set_frame(directionDict[direction])
		animator.play(directionAsString[direction]+"Rest")
		weapon.change_direction(directionDict[direction])
		#if(!weapon.isCharged and !weapon.is_hidden()):
		#	weapon.set_pos(10*direction)
	
func set_velocity():
	velocity = direction * walkSpeed
	
func numberOfDirectionsPressed():
	var num = 0
	for dir in ["ui_down", "ui_up", "ui_left", "ui_right"]:
		if(Input.is_action_pressed(dir)):
			num +=1
	return num


func gotHitByEnemy():
	if(hitTimer.get_time_left()==0):
		health -= 20
		healthBar.set_health(health)
		hitTimer.start()
		
func addHealth( amount):
	if(health + amount <= maxHealth):
			health += amount
	else:
		health == maxHealth

func swingHammer():
	weapon.isCharged = false
	var rotation  = 180
	if(direction == EAST):
		rotation = -180
	sEffect.interpolate_property(weapon, "transform/rot", 0 , rotation , .3 , 
			Tween.TRANS_BOUNCE, Tween.EASE_OUT)
	sEffect.interpolate_property(weapon, "transform/pos", Vector2(), direction*10, .3,
			Tween.TRANS_EXPO, Tween.EASE_OUT)	
	sEffect.start()

func _on_SwingEffect_tween_complete( object, key ):
	sEffect.reset(object,"transform/rot")
	sEffect.reset(object,"transform/pos")
	weapon.sheath()
	sEffect.stop_all()
