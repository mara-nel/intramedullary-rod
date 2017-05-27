extends CanvasLayer

var health = 100
var pBar
var regenerate = false #a boolean to keep track of if regeneration desired

func _ready():
	set_fixed_process(true)
	set_process_input(true)
	pBar = get_node("Control/ProgressBar")
	pBar.set_percent_visible(false)
	
func _input(event):
#	if(event.is_action_pressed("ui_focus_next")):
#		health += 20
	pass
	
func _fixed_process(delta):
	pBar.set_value(health)
	if(regenerate):
		if(health < pBar.get_max()):
			health += delta * 2

func set_health( newHealth ):
	health = newHealth
