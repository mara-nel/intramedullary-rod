extends Node

onready var enemies = get_tree().get_nodes_in_group("enemy")
# dont know if this breaks if no node exists or just gets set to null
onready var game = get_tree().get_nodes_in_group("Game")[0]

func _ready():
	
	for enemy in enemies:
		enemy.connect("dead", self, "on_enemy_death")
	
#	if(get_tree().get_node("Game") != null):
#		game = get_parent
	
	pass

func on_enemy_death():
	for enemy in enemies:
		if (enemy.isDead):
			enemy.queue_free()
			enemies.erase(enemy)