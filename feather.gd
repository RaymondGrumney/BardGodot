extends Node2D

@export var wobble_period = 0.75
@export var wobble_in_degrees = 15.0
@export var wobble_center = 60.0
var offset = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _physics_process(delta):
	var t = Time.get_ticks_msec()
#	print("$Sprite.rotation_degrees ", $Sprite.rotation_degrees)
#	print("                   wc-wd=", wobble_center - wobble_in_degrees)
#	print("                   delta ", delta)
#	print("   wobble_period * delta ", wobble_period * delta)
	if $Item/RigidBody2D/Sprite.rotation_degrees < wobble_center - wobble_in_degrees:
		$Item/RigidBody2D/Sprite.rotation_degrees += wobble_period
		offset = t
	else:
	#	print(get_parent().name, ": ", t)
		var rotation_degrees = sin( ( (offset + t) / ( wobble_period * 1000.0))) * wobble_in_degrees
		$Item/RigidBody2D/Sprite.rotation_degrees = rotation_degrees + wobble_center
