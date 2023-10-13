extends RigidBody2D

signal hit

@export var speed:int = 300
@export var jump_power:int = 300
@export var coins:int = 0
@export var dryads:int = 0
@export var attack:PackedScene
@export var attack_spawn_point_standing:Node2D
@export var attack_spawn_point_ducking:Node2D
@export var double_jump_enabled:bool = false
@export var double_jumped:bool      = false

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
var attack_spawn_point:Node2D 
var hearts:Array[AnimatedSprite2D]
var notes:Array[AnimatedSprite2D]

var screen_size


# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_viewport_rect().size
	attack_spawn_point = attack_spawn_point_standing
	for heart_container in find_child("HeartContainerRow").get_children():
		hearts.append(heart_container)
		heart_container.play("empty")
		heart_container.visible = false
#		print("heart_container.name     ", heart_container.name)
		for i in countable_inventory["hp"]["max"]:
#			print("max     ", i + 1)
			if heart_container.name == "HeartContainer{i}".format({"i":i + 1}):
#				print("make visible")
				heart_container.visible = true
		for i in countable_inventory["hp"]["current"]:
#			print("current ", i + 1)
			if heart_container.name == "HeartContainer{i}".format({"i":i + 1}):
#				print("make full")
				heart_container.play("full")
	for note_container in find_child("NoteContainerRow").get_children():
		notes.append(note_container)
		note_container.play("empty")
		note_container.visible = false
#		print("note_container.name     ", note_container.name)
#		print("countable_inventory['mp']['max']     ", countable_inventory["mp"]["max"])
#		print("countable_inventory['mp']['current'] ", countable_inventory["mp"]["current"])
		for i in countable_inventory["mp"]["max"]:
#			print("max     ", i + 1)
			if note_container.name == "NoteContainer{i}".format({"i":i + 1}):
#				print("make visible")
				note_container.visible = true
		for i in countable_inventory["mp"]["current"]:
#			print("current ", i + 1)
			if note_container.name == "NoteContainer{i}".format({"i":i + 1}):
#				print("make full")
				note_container.play("full")
#	print(hearts)
#	print(notes)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("attack"):
		var a = attack.instantiate()
		a.position = attack_spawn_point.position
		$Marker2D.add_child(a)

func _physics_process(delta):
	var velocity = Vector2.ZERO
	if Input.is_action_just_pressed("jump") and ( linear_velocity.y == 0 or (double_jump_enabled and not double_jumped) ):
		linear_velocity.y = -jump_power
	if Input.is_action_pressed("move_left"):
		linear_velocity.x = -speed
		$Marker2D.scale.x = -1
	if Input.is_action_pressed("move_right"):
		linear_velocity.x = speed
		$Marker2D.scale.x = 1

	if absf(linear_velocity.y) > 0.1:
		$Marker2D/AnimatedSprite2D.play("jump")
		if Input.is_action_just_released("duck"):
			attack_spawn_point = attack_spawn_point_standing
	elif Input.is_action_pressed("duck"):
		$Marker2D/AnimatedSprite2D.play("duck")
		attack_spawn_point = attack_spawn_point_ducking
	else:
		if Input.is_action_just_released("duck"):
			attack_spawn_point = attack_spawn_point_standing
			
		if double_jumped:
			double_jumped = false
		if absf(linear_velocity.x) > 0.1:
			$Marker2D/AnimatedSprite2D.play("run")
		else:
			$Marker2D/AnimatedSprite2D.play("stand")


func start(pos):
	position = pos
	$CollisionShape2D.disabled = false


## Update a value in CountableInventory
func _update_value(key:String, adjustment:int):
#	print(name, " _update_value: ", key, " ", adjustment)
#	print(name, " _update_value: ", " key.contains('_') ", key.contains("_"))
#	print(name, " _update_value: ", " countable_inventory.has(key.split('_')[0]) ", countable_inventory.has(key.split("_")[0]))
#	print(name, " _update_value: ", " countable_inventory.has(key.split('_')[0]) ", countable_inventory.has(key.split("_")[0]))
#	print(name, " _update_value: ", " key.split('_')[0] ", key.split("_")[0] )
#	print(name, " _update_value: ", " key.split('_')[1] ", key.split("_")[1] )

	## Check for substrings (ie, _max increases)
	if key.contains("_") and countable_inventory.has(key.split("_")[0]):
		countable_inventory[key.split("_")[0]][key.split("_")[1]] += adjustment
	## Check exact strings
	elif countable_inventory.has(key):
		## Verify the value is an int
		if countable_inventory[key] is int:
			countable_inventory[key] += adjustment
			print( key, ": ", countable_inventory[key] )
		## Check for those with `max` and `current` sub values,
		##   and `current` being less than `max`
		elif ( countable_inventory[key] is Dictionary
		and    countable_inventory[key]["current"] < countable_inventory[key]["max"] ):
#			print(countable_inventory[key]["current"])
			countable_inventory[key]["current"] += adjustment
#			print(countable_inventory[key]["current"])
	## Otherwise report that key was not matched
	else: print( name, ": key ", key, " not found." )

	if key == "hp_current" or key == "hp":
		if adjustment < 0:
			hearts[countable_inventory["hp"]["current"]].play("empty")
		elif adjustment > 0:
			hearts[countable_inventory["hp"]["current"] - 1].play("full")
	elif key == "coins":
		$HUD/Coins.text = str( countable_inventory[key] )

func _update_coins(adjustment:int):
	coins += adjustment
	$HUD/Coins.text = str(coins)
	print( coins )

func _add_dryad(adjustment:int=1):
	dryads += adjustment
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


func _on_takes_damage_damaged(collision):
#	print( "h ", $TakesDamage.health  )
#	print( "c ", countable_inventory["hp"]["current"] )
#	print( "d ", $TakesDamage.health - countable_inventory["hp"]["current"] )
	_update_value( "hp_current", $TakesDamage.health - countable_inventory["hp"]["current"] )
