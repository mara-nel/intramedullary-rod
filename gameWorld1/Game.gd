extends Node

#var mainChar
onready var window_size = OS.get_window_size()
onready var map_size = window_size
onready var player = get_node("MainChar")
onready var player_world_pos = get_body_grid_pos(player)
onready var enemies = get_tree().get_nodes_in_group("enemy")

onready var hBar = get_node("HealthBar")
onready var gameOverPanel = get_node("GameOverScreen")
onready var fps_label = get_node("HealthBar/FPSLabel")
onready var wilderness = get_node("Wilderness")

func _ready():
	var screen_size = OS.get_screen_size()
	#var window_size = OS.get_window_size()
	OS.set_window_position(screen_size*0.5 - window_size*0.5)
	map_size.x -= 16 #width of healthbar
	
	wilderness.connect("didWarp", self, "update_camera")
	
	
	update_camera()
	
	set_fixed_process(true)



func _fixed_process(delta):
	if(player.health <= 0):
		# moves the screen into the view of the main window
		# highly doubt this is good practice
		gameOverPanel.set_offset(Vector2())
		get_tree().set_pause(true)
	fps_label.clear()
	fps_label.add_text(str(OS.get_frames_per_second()))


func get_body_grid_pos( body):
	#converts the px pos of a body to the worlds grid system position
	var pos = body.get_pos()
	return (pos / map_size).floor()


func get_player_world_pos():
	return player_world_pos

func update_camera():	
	# the below is for a camera that follows the player
#	var canvas_transform = get_viewport().get_canvas_transform()
#	#canvas_transform[2] = player_world_pos * window_size
#	canvas_transform[2] = -player.get_pos() + window_size/2
#	get_viewport().set_canvas_transform(canvas_transform)

	# a 'fixed' camera that repositions when a player moves out of the window*
	# *minus any hud stuff
	var new_player_grid_pos = get_body_grid_pos(player)
	var transform = Matrix32()
	
	
	if(new_player_grid_pos != player_world_pos):
		player_world_pos = new_player_grid_pos
		transform = get_viewport().get_canvas_transform()
		transform[2] = -player_world_pos * map_size
		get_viewport().set_canvas_transform(transform)
		#update_live_enemies()

# by just using one big map, I'll have a lot of enemies wandering around
# im afraid that that could be bad for optimizing, if thats the case
# the goal of the below is to basically only do stuff for the enemies
# currently shown, but I didnt have much luck with that
func update_live_enemies():
	for enemy in enemies:
		if(get_body_grid_pos(enemy) != player_world_pos):
			#do something to hide/turn off/pause
			pass
		else:
			#turn the enemey on
			pass

# did this to update the camera after a warp (otherwise it points to wrong spot)
# but it seems that this would get triggered before scenemanager gets around to changing
# the chars position
func _on_Wilderness_didWarp():
	#update_camera()
	pass