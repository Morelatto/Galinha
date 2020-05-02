extends Node2D

onready var animation = $AnimationPlayer

func _ready():
	animation.play("float")

func _on_Area2D_body_entered(body):
	print("Egg collided with ", body.name)
	Globals.collected_eggs += 1
	queue_free()
