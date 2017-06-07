extends Node

onready var paddle = get_node("Paddle")
onready var bricks = get_tree().get_nodes_in_group("brick")
onready var ball  = preload("res://Ball.tscn")
onready var shootTimer = get_node("ReShoot")

var readyToShoot = true


func _ready():
	for brick in bricks:
		brick.connect("brickHitPaddle", self, "game_over")
		brick.connect("offScreen", self, "brickOffScreen")
	set_fixed_process(true)
	set_process_input(true)

func _input(event):
	var shoot = event.is_action_pressed("ui_accept")
	
	if(shoot and readyToShoot):
		var	b = ball.instance()
		add_child(b)
		b.set_pos(paddle.get_pos() + paddle.ballSpawnPt.get_pos())
		readyToShoot = false
		shootTimer.start()

	if(event.is_action_pressed("ui_cancel")):
		print(get_children().size())

func game_over():
	print("game over")
	get_tree().set_pause(true)

func brickOffScreen():
	pass



func _on_Timer_timeout():
	for brick in bricks:
		if(!brick.hit):
			brick.move(Vector2(0,20))


func _on_ReShoot_timeout():
	readyToShoot = true
