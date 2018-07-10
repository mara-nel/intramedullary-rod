extends Area2D

export (int) var TEAM

var can_move = true

var state
var validStates = ['rest', 'move', 'build']


func _ready():
	state = validStates[0]
	if TEAM == 2:
		get_node("Sprite").set_texture(load("res://p2.png"))


func move(location):
	position = location

func set_state(new_state):
	state = new_state

func set_state_rest():
	state = validStates[0]
func set_state_move():
	state = validStates[1]
func set_state_build():
	state = validStates[2]
	
func is_ready_to_move():
	return state == validStates[1]
func is_ready_to_build():
	return state == validStates[2]



func _process(delta):
	pass