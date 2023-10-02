extends RigidBody2D

signal hit

@export var speed:int = 300
@export var jump_power:int = 300
@export var coins:int = 0
@export var dryads:int = 0
@export var attack:PackedScene
@export var attack_spawn_point:Node2D
@export var countable_inventory:Dictionary = { 
	"sylphs":0,
	"oreads":0,
	"dryads":0,
	"coins":0,
	"hp": {
		"current": 3,
		"max": 3
	},
	"mp": {
		"current": 3,
		"max": 3
	}
}
@export var inventory:Array[Node2D]

var ducking:bool = false
var flipped:bool = false
var attack_spawn_point_starting_position:Vector2

var screen_size


# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_viewport_rect().size
	attack_spawn_point_starting_position = attack_spawn_point.position


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("attack"):
		var a = attack.instantiate()
		a.position = attack_spawn_point.position
		$Marker2D.add_child(a)

func _physics_process(delta):
	var velocity = Vector2.ZERO
	if Input.is_action_pressed("jump") and linear_velocity.y == 0:
		linear_velocity.y = -jump_power
	if Input.is_action_pressed("move_left"):
		linear_velocity.x = -speed
		$Marker2D.scale.x = -1
	if Input.is_action_pressed("move_right"):
		linear_velocity.x = speed
		$Marker2D.scale.x = 1
	if absf(linear_velocity.x) > 0.1:
		$Marker2D/AnimatedSprite2D.play("run")
	elif absf(linear_velocity.y) > 0.1:
		$Marker2D/AnimatedSprite2D.play("jump")
		
	elif ducking:
		$Marker2D/AnimatedSprite2D.play("ducking")
	else:
		$Marker2D/AnimatedSprite2D.play("stand")


func start(pos):
	position = pos
	$CollisionShape2D.disabled = false


#func _on_body_entered(body: RigidBody2D):
#	var collectible:Node
#	collectible=body.find_child("Collectible", true)
#	if(collectible):
#		print("TODO: add to inventory")
#	hit.emit()


## Update a value in CountableInventory
func _update_value(key:String, count:int):
#	print(name, " _update_value: ", key)

	## Check for substrings (ie, _max increases)
	if key.contains("_") and countable_inventory.has(key.split("_")[0]):
		countable_inventory[key.split("_")[0]][key.split("_")[1]]
	## Check exact strings
	elif countable_inventory.has(key):
		## Verify the value is an int
		if countable_inventory[key] is int:
			countable_inventory[key] += count
			if key == "coins":
				$HUD/Coins.text = str( countable_inventory[key] )
			print( key, ": ", countable_inventory[key] )
		## Check for those with `max` and `current` sub values,
		##   and `current` being less than `max`
		elif ( countable_inventory[key] is Dictionary
		and    countable_inventory[key]["current"] < countable_inventory[key]["max"] ):
			print(countable_inventory[key]["current"])
			countable_inventory[key]["current"] += count
			print(countable_inventory[key]["current"])
	## Otherwise report that key was not matched
	else: print( name, ": key ", key, " not found." )

func _update_coins(count:int):
	coins += count
	$HUD/Coins.text = str(coins)
	print( coins )

func _add_dryad(count:int=1):
	dryads += count
	print( "TODO: Update dryad" )

func _collect(item:PackedScene):
#	print( "TODO: add to inventory" )
#	print( item )
	if item:
		inventory.append( item.instantiate() )
		print(inventory.size())
		for i in inventory:
			print(i.name)
	else: print("item not sent")
