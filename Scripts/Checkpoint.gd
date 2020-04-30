extends Position2D

class_name Checkpoint
# oh god why
onready var world_controller = get_tree().get_root().get_child(0)
onready var chicken = get_tree().get_root().get_child(1).find_node("Chicken")
onready var collisionShape = $StaticBody2D/CollisionShape2D
onready var map = get_parent().get_parent()

var is_triggered = false
var converted_position = Vector2()

signal advanced_level

func _ready():
	converted_position = map.to_global(position)

func _process(delta):
	#32 is the chicken size
	var local_chicken = map.to_local(chicken.position)
	if !is_triggered and local_chicken.y < position.y - 32:
		trigger()
#-287.586
func trigger():
	#world_controller.load_next_world()
	collisionShape.disabled = false
	chicken.checkpoint = self
	is_triggered = true
	emit_signal("advanced_level")
