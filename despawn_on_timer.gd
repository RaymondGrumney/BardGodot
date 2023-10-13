extends Timer

func _on_timeout():
	var _parent = get_parent()
	for cs in _parent.find_children("CollisionShape2D"):
		cs.set_deferred("disabled", true)
	for spr in _parent.find_children("AnimatedSprite2D"):
		spr.play("despawn")
	_parent.hide()
	_parent.queue_free()
