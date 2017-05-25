extends Area2D


# The level to go when warped.
export (String, FILE) var target_level = null

func _ready():
	#connect("body_enter", self, "on_body_enter", [], CONNECT_ONESHOT)
	pass
	
func on_body_enter(body):
	if(body.is_in_group("player")):
		get_node("/root/scene_manager").transfer(target_level,"RIGHT",body.get_pos())


func _on_RightTransfer_body_enter( body ):
	if(body.is_in_group("player")):
		get_node("/root/scene_manager").transfer(target_level,"RIGHT",body.get_pos())

