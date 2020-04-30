extends RigidBody2D

var end = preload("res://Scenes/Stages/End.tscn")
var initial_position = Vector2()

func _ready():
	initial_position = position

func _process(delta):
	if position.y > initial_position.y + 200:
		get_tree().change_scene_to(end)
	
