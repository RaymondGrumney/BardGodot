extends Node

@export var knockback_force:Vector2 = Vector2(200, -100)
@export var stunable:bool = true
#@export var 
signal stun

func _knockback(collision):
	if collision:
		var rb = get_parent().find_child("RigidBody2D")
		var collision_position_x:float = collision.global_position.x
		var force = Vector2( sign((rb.global_position.x - collision_position_x)) , 1)
		force *= knockback_force
		stun.emit()
		rb.linear_velocity = force
	else: print("no collision sent")
