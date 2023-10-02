extends Node2D

## Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_timer_timeout():
	for cs in find_children("CollisionShape2D"):
		cs.set_deferred("disabled", true)
	for spr in find_children("AnimatedSprite2D"):
		spr.play("despawn")
	hide()
#	collect.emit(collectible)
	queue_free()
	
#	pass # Replace with function body.


func _on_area_2d_body_entered(body):
	print( name, " _on_area_2d_body_entered: ", body.name )
#	pass # Replace with function body.
