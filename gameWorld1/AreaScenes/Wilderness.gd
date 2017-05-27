extends Node

onready var enemies = get_tree().get_nodes_in_group("enemy")
onready var warpers = get_tree().get_nodes_in_group("warper")

signal didWarp

func _ready():
	
	for enemy in enemies:
		enemy.connect("dead", self, "on_enemy_death")
	for warper in warpers:
		warper.connect("warpTriggered", self, "on_warp_trigger")
	
	pass

func on_enemy_death():
	for enemy in enemies:
		if (enemy.isDead):
			enemy.queue_free()
			enemies.erase(enemy)

func on_warp_trigger():
	print("triggered")
	emit_signal("didWarp")
	