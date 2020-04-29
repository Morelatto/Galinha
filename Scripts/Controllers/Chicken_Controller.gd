extends RigidBody2D

class_name Chicken

const FLYING_SPEED = 5
const MIN_KICK_VELOCITY = 3
const FALLING_VELOCITY_THRESHOLD = 50
const MAX_FALLING_SPEED = 100

onready var checkpoint = Checkpoint.new()
onready var particles = get_parent().find_node("Particles")
onready var animation = get_node("AnimatedSprite")
onready var camera = get_node("Camera")

var can_kick = true
var is_falling = false

var is_in_respawn = false

func _ready():
	checkpoint.position = position

func apply_force(direction):
	apply_central_impulse(direction * FLYING_SPEED)
	camera.shake(0.5,10,5)

func emit_feathers(direction):
	particles.position = position
	particles.rotation = direction.angle()
	particles.emitting = true

func _physics_process(delta):
	if is_in_respawn:
		respawn()

func respawn():
	#32 is the size of the chicken.
	var respawn_pos = Vector2(checkpoint.converted_position.x, checkpoint.converted_position.y - 32)
	global_transform.origin = respawn_pos
	rotation = 0
	is_in_respawn = false

func _process(delta):
	can_kick = linear_velocity.length() < MIN_KICK_VELOCITY
	is_falling = linear_velocity.y > FALLING_VELOCITY_THRESHOLD
	var state = "Idle"
	if is_falling:
		state = "Falling"
		if linear_velocity.y > MAX_FALLING_SPEED:
			linear_velocity.y = MAX_FALLING_SPEED
	if animation.get_animation() != state:
		animation.set_animation(state)


func _on_Chicken_body_entered(body):
	if body.get_parent() is Spike:
		sleeping = true
		is_in_respawn = true
	elif body.get_parent() is SpringMushroom:
		var impulse = body.get_parent().get_force(position)
		apply_central_impulse(impulse)
	pass
