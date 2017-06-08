extends Node

onready var paddle = get_node("Paddle")
onready var bricks = get_tree().get_nodes_in_group("brick")
onready var ball  = preload("res://Ball.tscn")
onready var shootTimer = get_node("ReShoot")
onready var brickObject = preload("res://Brick.tscn")

onready var gameOverContainer = get_node("hud/GameOverCtr")

onready var gameOver = false
var readyToShoot = true
var YBrickSpawn = -50
var XBrickSpawn = 40

func _ready():
	gameOverContainer.hide()
	for brick in bricks:
		brick.connect("brickHitPaddle", self, "game_over")
		brick.connect("offScreen", self, "brickOffScreen")
	set_fixed_process(true)
	set_process_input(true)

func _input(event):
	var shoot = event.is_action_pressed("ui_accept")
	if(!gameOver):
		if(shoot and readyToShoot):
			var	b = ball.instance()
			b.set_pos(paddle.get_pos() + paddle.ballSpawnPt.get_pos())
			add_child(b)
			readyToShoot = false
			shootTimer.start()

		if(event.is_action_pressed("ui_cancel")):
			print(get_children().size())
	else:
		if(event.is_action_pressed("ui_accept")):
			newGame()
	
func game_over():
	gameOver = true
	gameOverContainer.show()
	get_tree().set_pause(true)

func brickOffScreen():
	for brick in bricks:
		if(brick.isOffScreen):
			print("removed")
			brick.queue_free()
			bricks.erase(brick)

func makeRowOfBricks():
	var XDisplaced = 0
	for x in range(0,4):
		var	br = brickObject.instance()
		add_child(br)
		br.set_pos(Vector2(XBrickSpawn+XDisplaced,YBrickSpawn))
		XDisplaced += 80
		bricks.append(br)
		br.connect("brickHitPaddle", self, "game_over")



func _on_Timer_timeout():
	for brick in bricks:
		if(!brick.hit):
			brick.move(Vector2(0,20))


func _on_ReShoot_timeout():
	readyToShoot = true


func _on_SpawnBricks_timeout():
	makeRowOfBricks()


func newGame():
	gameOver = false
	get_tree().set_pause(false)
	get_tree().reload_current_scene()
	
