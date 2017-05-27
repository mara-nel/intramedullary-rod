extends Node

#var mainChar
onready var window_size = OS.get_window_size()
onready var map_size = window_size
onready var player = get_node("MainChar")
onready var player_world_pos = get_player_grid_pos()

onready var hBar = get_node("HealthBar")
onready var gameOverPanel = get_node("GameOverScreen")

func _ready():
	var screen_size = OS.get_screen_size()
	#var window_size = OS.get_window_size()
	OS.set_window_position(screen_size*0.5 - window_size*0.5)
	map_size.x -= 16 #width of healthbar
	
	
	
	update_camera()
	
	set_fixed_process(true)



func _fixed_process(delta):
	if(player.health <= 0):
		# moves the screen into the view of the main window
		# highly doubt this is good practice
		gameOverPanel.set_offset(Vector2())
		get_tree().set_pause(true)


func get_player_grid_pos():
	# converts the players px location to the world grid position (think which area tile)
	var pos = player.get_pos() #- player.size /2
	var x = floor(pos.x /map_size.x)
	var y = floor(pos.y /map_size.y)
	return (pos / map_size).floor()


func update_camera():	
	# the below is for a camera that follows the player
#	var canvas_transform = get_viewport().get_canvas_transform()
#	#canvas_transform[2] = player_world_pos * window_size
#	canvas_transform[2] = -player.get_pos() + window_size/2
#	get_viewport().set_canvas_transform(canvas_transform)

	# a 'fixed' camera that repositions when a player moves out of the window*
	# *minus any hud stuff
	var new_player_grid_pos = get_player_grid_pos()
	var transform = Matrix32()
	
	if(new_player_grid_pos != player_world_pos):
		player_world_pos = new_player_grid_pos
		transform = get_viewport().get_canvas_transform()
		transform[2] = -player_world_pos * map_size
		get_viewport().set_canvas_transform(transform)
	

