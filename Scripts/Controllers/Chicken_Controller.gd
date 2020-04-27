extends RigidBody2D

const flying_speed = 5

var screen_size
var screen_buffer = 4 # how far the chicken can move off screen before it reappears on the other side

func apply_force(direction):
	apply_central_impulse(direction * flying_speed)

func _ready():
	screen_size = get_viewport_rect().size

#func _integrate_forces(state):
#	var xform = state.get_transform()
#	if xform.origin.x > screen_size.x:
#		xform.origin.x = 0
#	if xform.origin.x < 0:
#		xform.origin.x = screen_size.x
#	state.set_transform(xform)
