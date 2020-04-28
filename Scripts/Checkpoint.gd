extends Position2D

class_name Checkpoint
# oh god why
onready var chicken = get_parent().get_parent().get_parent().find_node("Chicken")
onready var collisionShape = $StaticBody2D/CollisionShape2D

var is_triggered = false

func _process(delta):
	#32 is the chicken size
	if !is_triggered and chicken.position.y < position.y - 32:
		trigger()

func trigger():
	collisionShape.disabled = false
	chicken.checkpoint = self
	is_triggered = true
