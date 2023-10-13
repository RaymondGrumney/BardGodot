extends Node

@export var health:float = 1
signal lethal_damage
signal damaged


func damage( damage:float, collision = null):
	print( get_parent().name, ": ",  damage)
	health -= damage
	damaged.emit(collision)
	if health <= 0:
		print("lethal")
		lethal_damage.emit(collision)
