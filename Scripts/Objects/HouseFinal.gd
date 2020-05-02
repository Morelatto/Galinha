extends RigidBody2D

onready var end = preload("res://Scenes/UI/End.tscn")

var initial_position = Vector2()

func _ready():
	initial_position = position

func _process(delta):
	if position.y > initial_position.y + 400:
		get_tree().change_scene_to(end)

