extends Area2D

# The level to go when warped.
export (String, FILE) var target_level = null

func _ready():
	connect("body_enter", self, "on_body_enter")
	
func on_body_enter(body):
	if(body.is_in_group("player")):
		get_node("/root/scene_manager").transfer(target_level,"UP",body.get_pos())


