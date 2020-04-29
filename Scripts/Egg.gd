extends Node2D

class_name Egg

const FLOATING_DISTANCE = 5

onready var initial_position = position
onready var ui_object = get_tree().get_root().get_child(0).get_node("UILayer")

var speed = 10
var is_going_up = true

func _process(delta):
	if is_going_up:
		position.y -= speed * delta
		if position.y < initial_position.y - FLOATING_DISTANCE:
			is_going_up = false
	else:
		position.y += speed * delta
		if position.y > initial_position.y:
			is_going_up = true




func _on_StaticBody2D_body_entered(body):
	if body is Chicken:
		ui_object.add_egg()
		queue_free()
	pass
