extends Node

const YBrickSpawn = 0
const  XBrickSpawn = 40

const ballCost = 10
const brickReward = 50


onready var paddle = get_node("Paddle")
onready var ball  = preload("res://Ball.tscn")
onready var shootTimer = get_node("ReShoot")
onready var brickObject = preload("res://Brick.tscn")
onready var gameOverContainer = get_node("hud/GameOverCtr")
onready var scoreDisplay = get_node("hud/ScoreCtr/RichTextLabel")

onready var bricks = get_tree().get_nodes_in_group("brick")
onready var balls = []

onready var score = 0

onready var gameOver = false
onready var readyToShoot = true

onready var bricksKnocked = 0
onready var ballsShot = 0


func _ready():
	gameOverContainer.hide()
	for brick in bricks:
		brick.connect("brickHitPaddle", self, "game_over")
		brick.connect("offScreen", self, "brickOffScreen")
		brick.connect("brickKnockedDown", self, "_on_BrickKnocked")
	set_fixed_process(true)
	set_process_input(true)

func _fixed_process(delta):
	score += 6*delta
	updateScore()


func _input(event):
	var shoot = event.is_action_pressed("ui_accept")
	if(!gameOver):
		if(shoot and readyToShoot and score-ballCost>=0):
			addBall()
			

		if(event.is_action_pressed("ui_cancel")):
			print(get_children().size())
	else:
		if(event.is_action_pressed("ui_accept")):
			newGame()
	
func game_over():
	gameOver = true
	gameOverContainer.show()
	
	print("Bricks knocked down: "+str(bricksKnocked))
	print("Balls shot: "+str(ballsShot))
	
	get_tree().set_pause(true)

func brickOffScreen():
	for brick in bricks:
		if(brick.isOffScreen):
			if(!brick.hit):
				game_over()
			brick.queue_free()
			bricks.erase(brick)

#creates a new row of bricks to slowly move down
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

# the function to add a ball to the game
func addBall():
	var	b = ball.instance()
	b.connect("outOfBounds", self, "ballOffScreen")
	b.set_pos(paddle.get_pos() + paddle.ballSpawnPt.get_pos())
	add_child(b)
	#start a short 'reload' timer
	readyToShoot = false
	shootTimer.start()
	score -= ballCost
	balls.append(b)
	
	ballsShot += 1

#removes balls that are off the screen (ie not coming back)
func ballOffScreen():
	for ball in balls:
		if(ball.isOffScreen):
			ball.queue_free()
			balls.erase(ball)


func _on_Timer_timeout():
	for brick in bricks:
		if(!brick.hit):
			brick.move(Vector2(0,20))


func _on_ReShoot_timeout():
	readyToShoot = true


func _on_SpawnBricks_timeout():
	makeRowOfBricks()

func _on_BrickKnocked():
	score += brickReward
	bricksKnocked +=1


func updateScore():
	scoreDisplay.clear()
	scoreDisplay.append_bbcode("[center]"+str(int(score))+"[/center]")


func newGame():
	gameOver = false
	get_tree().set_pause(false)
	get_tree().reload_current_scene()
	
