#Ghost controller is the class that will handle the user input
#since the player actually controls the ghost, not the chicken.
extends Node2D

var draw_line = false
var on_limit_kick = false

var initial_mouse_pos = Vector2()
var final_mouse_pos = Vector2()

#this was created because sometimes you can click the mouse
#when its not in a available kick state, so it does not
#capture the mouse position, BUT if you release the mouse
#in a available state it will kick based on the last available
#position.
var mouse_pressed_in_available_state = false

#Configuration
export var kick_speed = 7

#Load nodes
onready var chicken = get_parent().find_node("Chicken")

onready var boot_sprite = $BootSprite
onready var ghost_sprite = $GhostAnimatedSprite

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

# using _process instead of _physics_process to ensure animation is smooth with mouse movement
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
	if !chicken.can_kick:
		return

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
	if chicken.can_kick:
		# left click press
		if event.is_action_pressed("ui_mouse_action"):
			set_global_position(chicken.position)
			initial_mouse_pos = get_global_mouse_position()
			change_state(GHOST_STATE.in_preparing_for_kick)
			draw_line = true
			mouse_pressed_in_available_state = true

		# left click release
		if mouse_pressed_in_available_state and event.is_action_released("ui_mouse_action"):
			final_mouse_pos = get_global_mouse_position()
			change_state(GHOST_STATE.in_kick_animation)
			draw_line = false
			mouse_pressed_in_available_state = false


func _draw():
	if draw_line:
		var distance_to_chicken =  initial_mouse_pos - get_global_mouse_position()
		if distance_to_chicken.length() < MAX_LINE_DISTANCE:
			on_limit_kick = false
		else:
			on_limit_kick = true
		draw_kick_indicator(KICK_POLYGON_COLOR_RED if on_limit_kick else KICK_POLYGON_COLOR_GREEN)

func draw_kick_indicator(color):
	var polygons = PoolVector2Array()
	polygons.append(Vector2(5, -21))
	polygons.append(Vector2(1, 15))
	polygons.append(to_local(chicken.position))
	draw_colored_polygon(polygons, color)

func reset_kick():
	draw_line = false
	rotation = 0
	change_state(GHOST_STATE.in_free_mode)

