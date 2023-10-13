extends Node

func despawn(collsion = null):
#	print(get_parent().name, ".despawn")
	for cs in get_parent().find_children("CollisionShape2D"):
		cs.set_deferred("disabled", true)
	for spr in get_parent().find_children("AnimatedSprite2D"):
		spr.play("despawn")
	get_parent().hide()
	get_parent().queue_free()
