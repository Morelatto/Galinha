extends Position2D

class_name Checkpoint
# oh god why
onready var chicken = get_parent().get_parent().get_parent().find_node("Chicken")
onready var collisionShape = $StaticBody2D/CollisionShape2D
	
func _process(delta):
	#32 is the chicken size
	if chicken.position.y < position.y - 32:
		collisionShape.disabled = false
