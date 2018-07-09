extends KinematicBody2D

onready var ball = preload("res://Ball.tscn")
onready var ballSpawnPt = get_node("ballSpawn")

var LEFT = Vector2(-1,0)
var RIGHT = Vector2(1,0)
var moveSpeed = 125


func _ready():
	set_fixed_process(true)

	
func _fixed_process(delta):
	if(Input.is_action_pressed("ui_left")):
		move(LEFT*moveSpeed*delta)
		#set_pos(get_pos()+ LEFT*moveSpeed*delta)
	elif(Input.is_action_pressed("ui_right")):
		move(RIGHT*moveSpeed*delta)

