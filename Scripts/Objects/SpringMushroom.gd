extends Node2D

class_name SpringMushroom

export var bounciness = 100
export var direction = Vector2(0,10)

func get_force(nPosition):
	return (direction * bounciness)
