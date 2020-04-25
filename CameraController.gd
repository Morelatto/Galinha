#Camera has its own script so we can make a soft pan if we have time
extends Camera2D

onready var chicken = get_parent().find_node("Chicken")

func _process(delta):
	position = chicken.position
