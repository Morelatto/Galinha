extends Node2D

class_name SpringMushroom

export var bounciness = 100

func get_force(nPosition):
	return ((nPosition - position) * bounciness)
