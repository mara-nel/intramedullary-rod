extends CanvasLayer

onready var timer = get_node("Timer")
var outOfSite = Vector2(0,250)


func _ready():
	hideFromSight()
	pass
	


func start_timer():
	timer.start()

func _on_Timer_timeout():
	print("timedOut")
	hideFromSight()
	

func hideFromSight():
	set_offset(outOfSite)