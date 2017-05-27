extends Node

var mainChar
var gameOverPanel

func _ready():
	var screen_size = OS.get_screen_size()
	var window_size = OS.get_window_size()
	OS.set_window_position(screen_size*0.5 - window_size*0.5)
	
	mainChar = get_node("MainChar")
	gameOverPanel = get_node("GameOverScreen")

	
	set_fixed_process(true)

func _fixed_process(delta):
	if(mainChar.health <= 0):
		# moves the screen into the view of the main window
		# highly doubt this is good practice
		gameOverPanel.set_offset(Vector2())
		get_tree().set_pause(true)
		
	