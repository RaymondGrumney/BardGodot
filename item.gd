extends Node2D

signal update_value
@export var value:int = 1 
@export var key_to_update = "coins"
@export var initial_impact:Vector2 = Vector2(0,-200)
@export var initial_impact_variance:Vector2 = Vector2(50,-100)

#@export var sprite_frames:SpriteFrames

# Called when the node enters the scene tree for the first time.
func _ready():
	var player = find_parent("Main").find_child("Player")
	if player: self.update_value.connect( player._update_value )
	$RigidBody2D.linear_velocity = initial_impact + initial_impact_variance * ((randf()*2-1))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_body_entered(body):
	print(get_parent().name, " _on_body_entered: ", body.name)
	if(body.name == "Player"):
		update_value.emit( key_to_update, value )


func _on_timer_timeout():
	print("Enabling collection {", get_parent().name, "}")
#	$RigidBody2D.set_collision_layer_value(3,true)
#	$RigidBody2D.set_collision_layer_value(1,true)
	$RigidBody2D/Area2D.set_collision_mask_value(1,true)
	$RigidBody2D/Area2D.set_collision_layer_value(3,true)
