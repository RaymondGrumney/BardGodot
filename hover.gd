extends Node

@export var Sprite:AnimatedSprite2D
@export var hover_amplitude = 3.0
@export var hover_period = 3.0
@export var wobble_period = 1.5
@export var wobble_in_degrees = 5.0
var offset

# Called when the node enters the scene tree for the first time.
func _ready():
	offset = randf() * max(hover_period,wobble_period) * 1000
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var t = offset + Time.get_ticks_msec()
#	print(get_parent().name, ": ", t)
	var p = (sin( PI * t / (1000 * hover_period) ) + ( hover_period / 2.0 )) / 2
	var adjustment_x = hover_amplitude * ease( p, -1.0)
	var adjustment_y = hover_amplitude * exp(sin( PI * t / (1000 * hover_period / 2)))
	var rotation_degrees = sin( ( t / ( wobble_period * 1000.0))) * wobble_in_degrees
	Sprite.offset.x = adjustment_x
	Sprite.offset.y = adjustment_y
	Sprite.rotation_degrees = rotation_degrees
