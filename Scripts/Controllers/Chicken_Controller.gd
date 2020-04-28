extends RigidBody2D

const FLYING_SPEED = 5
const MIN_KICK_VELOCITY = 3

onready var particles = get_parent().find_node("Particles")

var can_kick = true

func apply_force(direction):
	apply_central_impulse(direction * FLYING_SPEED)

func emit_feathers(direction):
	particles.position = position
	particles.rotation = direction.angle()
	particles.emitting = true

func _process(delta):
	can_kick = linear_velocity.length() < MIN_KICK_VELOCITY
