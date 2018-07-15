extends Area2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

var squareSize 


func _ready():
	squareSize = 16 #main should manually set this

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass

func set_square_size(size):
	squareSize = size

func get_board_position():
	return position/squareSize
	
func set_board_position(pos):
	position = pos*squareSize