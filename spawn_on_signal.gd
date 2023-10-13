extends Node2D

@export var destroy_object_on_spawn:bool = true
@export var object_to_destroy:Node2D
@export var spawn_obect_on_destruction:Array[Dictionary]
@export var spawn_area:Node2D
var _used = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if _used:
		for s in spawn_obect_on_destruction:
			for o in s:
				if o is PackedScene:
					if s[o] is Dictionary:
						var position_offset = Vector2.ZERO
						if s[o].has( "position_offset" ):
							print("position_offset: ", s[o]["position_offset"])
							position_offset = s[o]["position_offset"]
						if s[o].has( "count" ):
							if s[o]["count"] > 0:
								_spawn( o, position_offset )
								s[o].count -= 1
								break
	#							print("count: ", s[o]["count"])
					if s[o] is int:
						if s[o] > 0:
							var obj:PackedScene = o
							for i in s[o]:
								_spawn(obj)
								s[o] -= 1
								break
					


func _take_damage(collision):
	print("_take_damage")
	if(destroy_object_on_spawn and object_to_destroy):
		for cs in object_to_destroy.find_children("CollisionShape2D"):
			cs.set_deferred("disabled", true)
		for spr in object_to_destroy.find_children("AnimatedSprite2D"):
			spr.play("Destroyed")
		object_to_destroy.hide()
		object_to_destroy.queue_free()
	_used = true


func _spawn(obj:PackedScene, position_offset:Vector2 = Vector2.ZERO):
	var p:Node2D = obj.instantiate()
	get_parent().add_child(p)
	if( spawn_area ):
		if( spawn_area is CollisionShape2D):
			var area:Vector2 = spawn_area.shape.get_rect().size
			var rand_offset:Vector2 = area * randf() - ( area / 2 )
			p.position = spawn_area.global_position + rand_offset
	else:
		p.position = position + position_offset
	
#class SpawnObjectList:
#	extends Node
#	@export var spawn:PackedScene
#	@export var count:int = 1

