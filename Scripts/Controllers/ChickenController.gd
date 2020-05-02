extends RigidBody2D

const FLYING_SPEED = 5
const MIN_KICK_VELOCITY = 3
const FALLING_VELOCITY_THRESHOLD = 50
const MAX_FALLING_SPEED = 100

onready var particles = $FeatherParticles
onready var animated_sprite = $AnimatedSprite
onready var camera = $Camera
onready var sound = $AudioStreamPlayer2D

var can_kick = true
var is_falling = false

var counting_delay = false
var delay_for_kick = 0.2
var delay_for_kick_count = 0

const unavailable_color = Color(0.8, 0.8, 0.8)
const available_color = Color(1, 1, 1)

var checkpoint: Transform2D
var respawn = false

func apply_force(direction):
	apply_central_impulse(direction * FLYING_SPEED)
	sound.play()
	camera.shake(0.5, 10, 5)

func emit_feathers(direction):
	#particles.position = position
	particles.rotation = direction.angle()
	particles.emitting = true

func _integrate_forces(state):
	if respawn:
		# correct way of modifying rigid body position
		state.set_transform(checkpoint)
		state.set_linear_velocity(Vector2.ZERO)
		state.set_angular_velocity(0.0)
		respawn = false

	if state.get_linear_velocity().y > FALLING_VELOCITY_THRESHOLD:
		state.linear_velocity.y = FALLING_VELOCITY_THRESHOLD
		is_falling = true
	else:
		is_falling = false

func _process(delta):
	check_if_can_kick(delta)
	animated_sprite.set_animation("Falling" if is_falling else "Idle")

func check_if_can_kick(delta):
	if linear_velocity.length() < MIN_KICK_VELOCITY:
		counting_delay = true
		#can_kick = true
	else:
		counting_delay = false
		delay_for_kick_count = 0
		can_kick = false
		animated_sprite.modulate = unavailable_color

	if counting_delay:
		delay_for_kick_count += delta
		if delay_for_kick_count > delay_for_kick:
			can_kick = true
			counting_delay = false
			delay_for_kick_count = 0
			animated_sprite.modulate = available_color
