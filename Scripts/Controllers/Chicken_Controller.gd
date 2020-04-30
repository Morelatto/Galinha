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
onready var sound = $AudioStreamPlayer2D

var can_kick = true
var is_falling = false

var counting_delay = false
var delay_for_kick = 0.2
var delay_for_kick_count = 0

var unavailable_color = Color(0.8,0.8,0.8)
var available_color = Color(1,1,1)

var is_in_respawn = false

func _ready():
	checkpoint.position = position

func apply_force(direction):
	apply_central_impulse(direction * FLYING_SPEED)
	sound.play()
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
	check_if_can_kick(delta)
	is_falling = linear_velocity.y > FALLING_VELOCITY_THRESHOLD
	var state = "Idle"
	if is_falling:
		state = "Falling"
		if linear_velocity.y > MAX_FALLING_SPEED:
			linear_velocity.y = MAX_FALLING_SPEED
	if animation.get_animation() != state:
		animation.set_animation(state)

func check_if_can_kick(delta):
	if linear_velocity.length() < MIN_KICK_VELOCITY:
		counting_delay = true
		#can_kick = true
	else:
		counting_delay = false
		delay_for_kick_count = 0
		can_kick = false
		$AnimatedSprite.modulate = unavailable_color

	if counting_delay:
		delay_for_kick_count += delta
		if delay_for_kick_count > delay_for_kick:
			can_kick = true
			counting_delay = false
			delay_for_kick_count = 0
			$AnimatedSprite.modulate = available_color


func _on_Chicken_body_entered(body):
	if body.get_parent() is Spike:
		sleeping = true
		is_in_respawn = true
	elif body.get_parent() is SpringMushroom:
		var impulse = body.get_parent().get_force(position)
		apply_central_impulse(impulse)
	pass
