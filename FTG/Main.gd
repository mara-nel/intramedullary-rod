extends Node

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
# Directions
var DOWN = Vector2(0,1)
var RIGHT = Vector2(1,0)
var LEFT = Vector2(-1,0)

# Values of entries in boardArray
var EMPTY = 0


var boardArray = []
var BOARD_WIDTH = 10
var BOARD_HEIGHT = 22

var squareSize = 16

var testBlock

var gravityCheck = 15
var running = 0
var FALL_LOCK = 3
var timeOnFloor = 0 


func _ready():
	makeBoard()

	#print(boardArray)
	
	new_block()
	# Called every time the node is added to the scene.
	# Initialization here
	pass

func _process(delta):
	# Called every frame. Delta is time since last frame.
	# Update game logic here.
	running += 1
	if running >= gravityCheck:
		running = 0
		if !move(DOWN, testBlock):
			timeOnFloor +=1
			if timeOnFloor >= FALL_LOCK:
				piece_locked()
				timeOnFloor = 0
		

func _input(event):
	if event is InputEventMouseButton:
		pass
	#eventually want some sort of restart button
	elif event is InputEventKey:
		#META: I question if I need to be passing along testBlock, there
		#	could just be a single live piece and these functions just apply
		#	to the live piece
		if Input.is_key_pressed(KEY_DOWN):
			#print('down?')
			move(DOWN, testBlock)
		elif Input.is_key_pressed(KEY_RIGHT):
			#print('down?')
			move(RIGHT, testBlock)
		elif Input.is_key_pressed(KEY_LEFT):
			#print('down?')
			move(LEFT, testBlock)
		
		if Input.is_key_pressed(KEY_P):
			printBoard()
			
		if Input.is_key_pressed(KEY_SPACE):
			drop(testBlock)

#THOUGHT: pieces can be added to groups -> could be useful for making squares
func new_block():
	var scene = load("res://Square.tscn")
	var scene_instance = scene.instance()
	get_node("blocks").add_child(scene_instance)
	testBlock = scene_instance
	testBlock.set_square_size(squareSize)
	testBlock.set_board_position(Vector2(5,0))
	
# does everything that should be done once a piece gets locked in
func piece_locked():
	check_for_lines()

	new_block()

func check_for_lines():
	for i in range(0,BOARD_HEIGHT):
		var row = boardArray[i]
		var space = false
		for entry in row:
			if entry == EMPTY:
				space = true
		if !space:
			print('line full')
			clear_row(i)

func clear_row(row):
	#need to clear pieces
	for piece in get_node("blocks").get_children():
		var pieceCoord = piece.get_board_position()
		if pieceCoord[1] == row:
			piece.queue_free()
		elif pieceCoord[1] < row:
			piece.set_board_position(pieceCoord + DOWN)
	update_board()


func move(direction, piece):
	var old_pos = piece.get_position()
	var change = direction*squareSize
	if can_move(direction, piece):
		piece.set_position(old_pos + change)
		update_board()
		return true
	else:
		return false

func can_move(direction, piece):
	var new_position = piece.get_board_position() + direction
	if !off_board(new_position):
		if !board_occupied(new_position):
			return true 
	else:
		return false
		
	
func drop(piece):
	while(move(DOWN,piece)):
		pass
	piece_locked()
	
	
	
func off_board(new_position):
	if new_position.x <0:
		return true 
	elif new_position.x > BOARD_WIDTH-1:
		return true
	elif new_position.y > BOARD_HEIGHT-1:
		return true
	else:
		return false
		

func board_occupied(new_position):
	if boardArray[new_position.y][new_position.x] != 0:
		#print('occupied')
		return true
	else:
		return false




func update_board():
	makeBoard() #zeros it out
	for piece in get_node("blocks").get_children():
		var pieceCoord = piece.get_board_position()
		boardArray[pieceCoord[1]][pieceCoord[0]] = 1



# Constructs the boardArray to be the size of our play field
# Calling boardArray[row][col] returns the element that lives in the 
#  row-th row from the top and the col-th column from the left
func makeBoard():
	boardArray = [] #makes sure the board is empty
	for x in range(0,BOARD_HEIGHT):
		var row = []
		for y in range(0,BOARD_WIDTH):
			row.append(EMPTY)
		boardArray.append(row)
	
func printBoard():
	print("---------------------------")
	for x in range(0,BOARD_HEIGHT):
		print(boardArray[x])
		
		


func new_piece():
	#choose what it'll be
	#construct it
	#set it to the active piece
	pass


var I = [
		[0, 0, 0, 0],
		[1, 1, 1, 1],
		[0, 0, 0, 0],
		[0, 0, 0, 0]
	]

var pieces = [I]
