extends Area2D

export (int) var SPEED

var screensize
var tile_size = 64
var can_move = true
var moves = {'right': Vector2(1,0), 
			 'left': Vector2(-1,0),
			 'up': Vector2(0,-1),
			 'down': Vector2(0,1) }



func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	screensize = get_viewport_rect().size


func move(dir):
	pass


func _process(delta):
	var velocity = Vector2() # the player's movement vector
	if Input.is_action_pressed("ui_right"):
		velocity.x += 1
	if Input.is_action_pressed("ui_left"):
		velocity.x -= 1
	if Input.is_action_pressed("ui_down"):
		velocity.y += 1
	if Input.is_action_pressed("ui_up"):
		velocity.y -= 1
	if velocity.length() > 0:
		velocity = velocity.normalized() * SPEED

	position += velocity * delta
	position.x = clamp(position.x, 0, screensize.x)
	position.y = clamp(position.y, 0, screensize.y)