extends Node

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	var screen_size = OS.get_screen_size()
	var window_size = OS.get_window_size()
	OS.set_window_position(screen_size*0.5 - window_size*0.5)
	pass
