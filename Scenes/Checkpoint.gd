extends Position2D

onready var chicken = get_parent().find_node("Chicken")
onready var collisionShape = get_child(0).get_child(0)

func _process(delta):
	#32 is the chicken size
	if chicken.position.y < (position.y - 32):
		collisionShape.disabled = false
