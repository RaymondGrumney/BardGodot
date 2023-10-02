extends Area2D

var starting_position
@export var hover_amplitude = 3.0
@export var hover_period = 3.0
@export var wobble_period = 1.5
@export var wobble_in_degrees = 5.0

signal add_dryad

# Called when the node enters the scene tree for the first time.
func _ready():
	starting_position=position
	var player = get_parent().get_node("Player")
	self.add_dryad.connect(player._add_dryad)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var p = (sin( PI * Time.get_ticks_msec() / (1000 * hover_period) ) + ( hover_period / 2.0 )) / 2
	var adjustment_x = hover_amplitude * ease( p, -1.0)
	var adjustment_y = hover_amplitude * exp(sin( PI * Time.get_ticks_msec() / (1000 * hover_period / 2)))
	var rotate = sin( ( Time.get_ticks_msec() / ( wobble_period * 1000.0))) * wobble_in_degrees
	position.x = starting_position.x + adjustment_x
	position.y = starting_position.y + adjustment_y
	rotation_degrees = rotate

# Collision with player
func _on_body_entered(body):
	if(body.name == "Player"):
		add_dryad.emit()


func _on_timer_timeout():
	print("Enabling collection {", self, "}")
	set_collision_mask_value(1,true)
	set_collision_layer_value(3,true)
