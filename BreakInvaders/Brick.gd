extends KinematicBody2D

var DOWN = Vector2(0,1)
var fallSpeed = 75
onready var hit = false
onready var isOffScreen = false
### get this value from somewhere else
var bottomScreen = 512

signal brickHitPaddle
signal offScreen
signal brickKnockedDown

func _ready():
	set_fixed_process(true)

func _fixed_process(delta):
	if(hit):
		move(DOWN*fallSpeed*delta)
		if(get_pos().y > bottomScreen):
			emit_signal("offScreen")
	if(is_colliding()):
		var coll = get_collider()
		if(coll.get_name() == "Paddle"):
			emit_signal("brickHitPaddle")
			
	if(get_pos().y>bottomScreen):
		isOffScreen = true
		emit_signal("offScreen")
		


func wasHit():
	hit = true
	set_collision_mask_bit(0,false)
	set_collision_mask_bit(1,true)
	set_layer_mask_bit(0,false)
	#set_layer_mask_bit(1,true)
	emit_signal("brickKnockedDown")
