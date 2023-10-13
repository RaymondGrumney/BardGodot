extends Area2D

@export var groups_damaged:Array[String]
@export var damage_dealt:float

func _deal_damage(collision):
	var target
#	print(collision)
#	print("_deal_damage ", group_damaged)
	for g in groups_damaged:
		print(g)
		if(not target):
			print("a")
			print(collision)
			print(collision.get_parent())
			if(collision.get_parent().is_in_group(g)):
				print("b")
				target = collision.get_parent()
				break
			elif(collision.is_in_group(g)):
				print("c")
				target = collision
				break

	print(target)
	if(target):
		print("is in group")
		var takes_damage = target.find_child("TakesDamage")
		if takes_damage:
			print("can take damage")
			takes_damage.damage(damage_dealt, get_parent())
