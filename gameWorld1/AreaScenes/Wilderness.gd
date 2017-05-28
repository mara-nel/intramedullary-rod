extends Node

onready var enemies = get_tree().get_nodes_in_group("enemy")
onready var warpers = get_tree().get_nodes_in_group("warper")

signal didWarp
signal allEnemiesDead

func _ready():
	set_process_input(true) #just for some debug features
	for enemy in enemies:
		enemy.connect("dead", self, "on_enemy_death")
	for warper in warpers:
		warper.connect("warpTriggered", self, "on_warp_trigger")
	
	pass

func _input(event):
	if(event.is_action_pressed("ui_focus_next")):
		print(str(enemies.size()))

func on_enemy_death():
	for enemy in enemies:
		if (enemy.isDead):
			enemy.queue_free()
			enemies.erase(enemy)
	if(enemies.size() == 0):
		emit_signal("allEnemiesDead")

func on_warp_trigger():
	print("triggered")
	emit_signal("didWarp")
	