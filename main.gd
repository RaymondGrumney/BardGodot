extends Node

@export var mob_scene: PackedScene
var score


func _ready():
	print("_ready")
	new_game()


func game_over():
	print("game_over")
	$ScoreTimer.stop()
	$MobTimer.stop()


func new_game():
	print("New Game")
	score = 0
	$Player.start($PlayerStartingPosition.position)


#func _on_start_timer_timeout():
#	print("_on_start_timer_timeout")
#	$MobTimer.start()
#	$ScoreTimer.start()


#func _on_mob_timer_timeout():
#	("_on_mob_timer_timeout")
#	var mob = mob_scene.instantiate()
#	var mob_spawn_location = get_node("MobPath/MobSpawnLocation")
#	mob_spawn_location.progress_ratio = randf()
#	var direction = mob_spawn_location.rotation + PI/2
#	mob.position = mob_spawn_location.position
#	direction += randf_range(-PI / 4, PI / 4)
#	mob.rotation = direction
#	var velocity = Vector2(randf_range(150.0,250.0),0.0)
#	mob.linear_velocity = velocity.rotated(direction)
#	add_child(mob)
