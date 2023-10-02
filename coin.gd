extends RigidBody2D

signal update_value
@export var value:int = 1 
@export var key_to_update = "coins"
@export var initial_impact:Vector2 = Vector2(0,-200)
@export var initial_impact_variance:Vector2 = Vector2(50,-100)

# Called when the node enters the scene tree for the first time.
func _ready():
	var player = get_parent().get_node( "Player" )
	self.update_value.connect( player._update_value )
	linear_velocity = initial_impact + initial_impact_variance * ((randf()*2-1))
#	print(linear_velocity)
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_body_entered(body):
	if(body.name == "Player"):
		update_value.emit( key_to_update, value )


func _on_timer_timeout():
#	print("Enabling collection {", self, "}")
	set_collision_layer_value(3, true)
	pass
