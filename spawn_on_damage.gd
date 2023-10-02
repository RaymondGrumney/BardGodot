extends Node2D

@export var receives_damage_as_enemy:bool = true
@export var receives_damage_as_player:bool = false
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
	pass


func _on_area_entered(area):
	print("test2342342")
	if( _can_take_damage(area) ): _take_damage()


func _on_body_entered(body):
	if( _can_take_damage(body) ): _take_damage()


func _can_take_damage(obj):
	return (( receives_damage_as_enemy  and obj.is_in_group("damages_enemies" ))
		or (  receives_damage_as_player and obj.is_in_group("damages_players" )))
	

func _take_damage():
	print("_take_damage")
	for dict in spawn_obect_on_destruction:
		for obj in dict:
			if obj is PackedScene:
				if dict[obj] is Dictionary:
					var position_offset = Vector2.ZERO
					if dict[obj].has( "position_offset" ):
						print("position_offset: ", dict[obj]["position_offset"])
						position_offset = dict[obj]["position_offset"]
					if dict[obj].has( "count" ):
						for i in dict[obj]["count"]:
							_spawn( obj, position_offset )
						print("count: ", dict[obj]["count"])
				if dict[obj] is int:
					var o:PackedScene = obj
					for i in dict[o]:
						_spawn(obj)
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
#	p.position = position + position_offset
	
#class SpawnObjectList:
#	extends Node
#	@export var spawn:PackedScene
#	@export var count:int = 1

