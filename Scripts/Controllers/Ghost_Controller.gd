#Ghost controller is the class that will handle the user input
#since the player actually controls the ghost, not the chicken.
extends Node2D

var drawLine = false
var can_kick = true
var on_limit_kick = false

var initial_mouse_pos = Vector2()
var final_mouse_pos = Vector2()

#Configuration
export var kick_speed = 10
var kick_polygon_color = Color(0.058, 0.735, 0)

#Load nodes
onready var chicken = get_parent().find_node("Chicken")
onready var camera = get_parent().find_node("Camera")

onready var boot_sprite = $BootSprite
onready var ghost_sprite = $GhostAnimatedSprite

const MIN_KICK_VELOCITY = 5
const MIN_GHOST_DISTANCE = 8
const MAX_LINE_DISTANCE = 200
const KICK_POLYGON_COLOR_GREEN = Color(0.058, 0.735, 0, 0.5)
const KICK_POLYGON_COLOR_RED = Color(0.735, 0.058, 0, 0.5)

enum GHOST_STATE {
	in_kick_animation
	in_preparing_for_kick
	in_free_mode
}

var state = GHOST_STATE.in_free_mode

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)

func _process(delta):
	if state == GHOST_STATE.in_kick_animation:
		_calculate_kick_animation(delta)
	elif state == GHOST_STATE.in_preparing_for_kick:
		_calculate_prepare_for_kick()
	else:
		# sets the ghost position to the mouse position
		position = get_global_mouse_position()
	update()

func _calculate_kick_animation(delta):
	var direction_player = position - chicken.position
	direction_player = direction_player * (kick_speed * delta)
	translate(-direction_player)
	# distance from mouse (ghost) to chicken
	if position.distance_to(chicken.position) < MIN_GHOST_DISTANCE:
		var distance_force = initial_mouse_pos - final_mouse_pos
		if initial_mouse_pos.distance_to(final_mouse_pos) > MAX_LINE_DISTANCE:
			distance_force = distance_force.normalized() * MAX_LINE_DISTANCE
		chicken.apply_force(distance_force)
		chicken.emit_feathers(chicken.position - position)
		reset_kick()

func _calculate_prepare_for_kick():
	look_at(chicken.position)
	var mouse_position = get_global_mouse_position()
	var mouse_direction = initial_mouse_pos - mouse_position
	# TODO fix kick up
	if mouse_direction.x < 0:
		boot_sprite.flip_v = true
	else:
		boot_sprite.flip_v = false
	var new_position = chicken.position - mouse_direction
	if on_limit_kick:
		new_position = mouse_direction.normalized() * -MAX_LINE_DISTANCE
		new_position = chicken.position + new_position
	position = new_position

func change_state(new_state):
	state = new_state
	match new_state:
		GHOST_STATE.in_free_mode:
			rotation = 0
			boot_sprite.hide()
			ghost_sprite.show()

		GHOST_STATE.in_kick_animation:
			boot_sprite.show()
			ghost_sprite.hide()

		GHOST_STATE.in_preparing_for_kick:
			boot_sprite.show()
			ghost_sprite.hide()


func _input(event):
	# prevent kicking in the air
	if chicken.linear_velocity.length() < MIN_KICK_VELOCITY:
		# left click press
		if event.is_action_pressed("ui_mouse_action"):
			set_global_position(chicken.position)
			initial_mouse_pos = get_global_mouse_position()
			change_state(GHOST_STATE.in_preparing_for_kick)
			drawLine = true

		# left click release
		if event.is_action_released("ui_mouse_action") and drawLine:
			final_mouse_pos = get_global_mouse_position()
			change_state(GHOST_STATE.in_kick_animation)
			drawLine = false


func _draw():
	if drawLine:
		var distance_to_chicken =  initial_mouse_pos - get_global_mouse_position()
		if distance_to_chicken.length() < MAX_LINE_DISTANCE:
			kick_polygon_color = KICK_POLYGON_COLOR_GREEN
			on_limit_kick = false
		else:
			kick_polygon_color = KICK_POLYGON_COLOR_RED
			on_limit_kick = true
		var polygons = PoolVector2Array()
		polygons.append(Vector2(5, -21))
		polygons.append(Vector2(1, 15))
		polygons.append(to_local(chicken.position))
		draw_colored_polygon(polygons, kick_polygon_color)
		#else:

			#reset_kick()

func reset_kick():
	drawLine = false
	change_state(GHOST_STATE.in_free_mode)
	rotation = 0
