extends Node2D

export var bounciness = 100
export var direction = Vector2(0, 50)

func _on_Area2D_body_entered(chicken):
	print("Spring mushroom collided with ", chicken.name)
	var force = direction * bounciness
	chicken.apply_central_impulse(force)
