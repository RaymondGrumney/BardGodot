extends Node2D

@export var initial_impact:Vector2 = Vector2(0,-200)
@export var initial_impact_variance:Vector2 = Vector2(50,-100)
@export var away_from_player:bool = false

# Called when the node enters the scene tree for the first time.
func _physics_process(delta):
	var base = Vector2.ONE
	if away_from_player:
		print("global_position.x:              ", global_position.x)
		print("global_position:                ", global_position)
#		print("position:                       ", position)
		var playerPosX:float = find_parent("Main").find_child("Player").global_position.x
		print("playerPosX:                     ", playerPosX)
		print("global_position.x - playerPosX: ", global_position.x - playerPosX)
		print("sign:                           ", sign(global_position.x - playerPosX))
		base.x = sign(global_position.x - playerPosX)
#	print(base)
	get_parent().linear_velocity = base * initial_impact + initial_impact_variance * ((randf()*2-1))
	queue_free()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	print("global_position:                ", global_position)
#	print("position:                       ", position)
	pass
