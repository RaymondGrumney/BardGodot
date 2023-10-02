extends Node

## The inventory item to be collected
@export var collectible:PackedScene

## The parent object
var _parent:Node2D

## Sent to _collect on player object
signal collect

## Called when the node enters the scene tree for the first time.
func _ready():
	
	_parent = get_parent()
	var player = find_parent("Main").get_node("Player")
	if player:
		self.collect.connect(player._collect)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

## 
func _collected(body):
	if(body.name == "Player"):
		for cs in _parent.find_children("CollisionShape2D"):
			cs.set_deferred("disabled", true)
		for spr in _parent.find_children("AnimatedSprite2D"):
			spr.play("Collected")
		_parent.hide()
		collect.emit(collectible)
		queue_free()
