extends RigidBody2D

const flying_speed = 10

func apply_force(direction):
	apply_central_impulse(direction * flying_speed)
