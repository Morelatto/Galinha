extends Node2D

onready var area_collision = $Area2D/CollisionShape2D
onready var spawn_point = $RespawnPoint

signal advanced_level

var is_above = false

# same thing as spikes with checkpoints
# only collides with the player because of the layer
func _on_Area2D_body_entered(chicken):
	if is_above:
		crete_standing_platform()
		chicken.checkpoint = spawn_point.global_transform
		emit_signal("advanced_level")
	else:
		is_above = true

# enabling a pre existing collision shape by code wasn't working so had to
# create it in runtime
func crete_standing_platform():
	var collision = area_collision.duplicate()
	var body = StaticBody2D.new()
	body.add_child(collision)
	add_child(body)
	# disabling so signal isn't triggered again
	area_collision.disabled = true
