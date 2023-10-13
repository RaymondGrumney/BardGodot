extends Node

@export var hover_amplitude = 3.0
@export var hover_period = 3.0
var initial_position
var offset

# Called when the node enters the scene tree for the first time.
func _ready():
	offset = randf() * hover_period * 1000
	initial_position = $StaticBody2D.position

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _physics_process(delta):
	var t = offset + Time.get_ticks_msec()
#	print(get_parent().name, ": ", t)
	var p = (sin( PI * t / (1000 * hover_period) ) + ( hover_period / 2.0 )) / 2
	var adjustment_x = hover_amplitude * ease( p, -1.0)
	var adjustment_y = hover_amplitude * exp(sin( PI * t / (1000 * hover_period / 2)))
#	$StaticBody2D.position.x = initial_position.x + adjustment_x
	$StaticBody2D.position.y = initial_position.y + adjustment_y
