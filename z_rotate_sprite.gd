extends Node2D

@export var rotate_speed:float = 1
var t_offset:float
var scale_x:float

func _ready():
	t_offset = randf() * rotate_speed * 1000

	scale_x = scale.x

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var t = t_offset + Time.get_ticks_msec()
	var p = sin( PI * t / (1000 * rotate_speed) )
	scale.x = p
