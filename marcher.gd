extends Node2D

@export var marching_speed:int = 100
@export var hesitation_on_turn:float = 0.5
var marching_direction:Vector2 = Vector2(1,0)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _physics_process(delta):
#	print($Timer.time_left)
#	print($RigidBody2D.linear_velocity)
	if $Timer.time_left == 0.0:
		if $RigidBody2D.linear_velocity == Vector2.ZERO:
			marching_direction *= -1
			stunned()
#			$AnimatedSprite2D.play("Confused")
		else: 
			$RigidBody2D.linear_velocity.x = marching_direction.x * marching_speed
#			$AnimatedSprite2D.play("March")


func _on_timer_timeout():
	$RigidBody2D.linear_velocity.x = marching_direction.x * marching_speed
#	$AnimatedSprite2D.play("March")

func stunned():
#	print("stunned")
	$Timer.wait_time = hesitation_on_turn
	$Timer.start()
