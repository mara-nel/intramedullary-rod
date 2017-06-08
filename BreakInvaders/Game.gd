extends Node

onready var paddle = get_node("Paddle")
onready var bricks = get_tree().get_nodes_in_group("brick")
onready var ball  = preload("res://Ball.tscn")
onready var shootTimer = get_node("ReShoot")
onready var brickObject = preload("res://Brick.tscn")

onready var gameOverContainer = get_node("hud/GameOverCtr")

onready var score = 0
onready var scoreDisplay = get_node("hud/ScoreCtr/RichTextLabel")


onready var gameOver = false
var readyToShoot = true
const YBrickSpawn = -50
const  XBrickSpawn = 40

func _ready():
	gameOverContainer.hide()
	for brick in bricks:
		brick.connect("brickHitPaddle", self, "game_over")
		brick.connect("offScreen", self, "brickOffScreen")
		brick.connect("brickKnockedDown", self, "_on_BrickKnocked")
	set_fixed_process(true)
	set_process_input(true)

func _fixed_process(delta):
	score += 5*delta
	updateScore()


func _input(event):
	var shoot = event.is_action_pressed("ui_accept")
	if(!gameOver):
		if(shoot and readyToShoot):
			var	b = ball.instance()
			b.set_pos(paddle.get_pos() + paddle.ballSpawnPt.get_pos())
			add_child(b)
			readyToShoot = false
			shootTimer.start()
			score -= 10

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
		br.connect("brickKnockedDown", self, "_on_BrickKnocked")
		br.connect("offScreen", self, "brickOffScreen")


func _on_Timer_timeout():
	for brick in bricks:
		if(!brick.hit):
			brick.move(Vector2(0,20))


func _on_ReShoot_timeout():
	readyToShoot = true


func _on_SpawnBricks_timeout():
	makeRowOfBricks()

func _on_BrickKnocked():
	score += 100


func updateScore():
	scoreDisplay.clear()
	scoreDisplay.append_bbcode("[right]"+str(int(score))+"[/right]")


func newGame():
	gameOver = false
	get_tree().set_pause(false)
	get_tree().reload_current_scene()
	
