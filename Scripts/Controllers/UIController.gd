extends Node2D

onready var egg_text = get_child(0).get_child(0).get_child(0)

var egg_quantity = 0

func add_egg():
	egg_quantity += 1
	egg_text.set_text(str("x", egg_quantity))
