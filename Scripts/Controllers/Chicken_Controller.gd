extends RigidBody2D

const FLYING_SPEED = 5
const MIN_KICK_VELOCITY = 3

onready var checkpoint = Checkpoint.new()
onready var particles = get_parent().find_node("Particles")

var can_kick = true

var is_in_respawn = false

func _ready():
	checkpoint.position = position

func apply_force(direction):
	apply_central_impulse(direction * FLYING_SPEED)

func emit_feathers(direction):
	particles.position = position
	particles.rotation = direction.angle()
	particles.emitting = true

func _physics_process(delta):
	if is_in_respawn:
		respawn()

func respawn():
	#32 is the size of the chicken.
	var respawn_pos = Vector2(checkpoint.position.x, checkpoint.position.y - 32)
	global_transform.origin = respawn_pos
	rotation = 0
	is_in_respawn = false

func _process(delta):
	can_kick = linear_velocity.length() < MIN_KICK_VELOCITY


func _on_Chicken_body_entered(body):
	if body.get_parent() is Spike:
		sleeping = true
		is_in_respawn = true
	if body.get_parent() is SpringMushroom:
		var impulse = body.get_parent().get_force(position)
		apply_central_impulse(impulse)
	pass
