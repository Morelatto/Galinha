#Ghost controller is the class that will handle the user input
#since the player actually controls the ghost, not the chicken.
extends Node2D

var drawLine = false
var can_kick = true

var initial_mouse_pos = Vector2()
var final_mouse_pos = Vector2()

#Configuration
export var kick_speed = 10

#Load nodes
onready var chicken = get_parent().find_node("Chicken")
onready var camera = get_parent().find_node("Camera")

onready var boot_sprite = $BootSprite
onready var ghost_sprite = $GhostAnimatedSprite

const MIN_KICK_VELOCITY = 5
const MIN_GHOST_DISTANCE = 8
const MAX_LINE_DISTANCE = 200
const KICK_POLYGON_COLOR = Color(0.058, 0.735, 0)

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
		chicken.apply_force(initial_mouse_pos - final_mouse_pos)
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
	position = chicken.position - mouse_direction

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
			rotation = 0
			drawLine = false


func _draw():
	if drawLine:
		var distance_to_chicken = to_local(chicken.position)
		if distance_to_chicken.length() < MAX_LINE_DISTANCE:
			var polygons = PoolVector2Array()
			polygons.append(Vector2(5, -21))
			polygons.append(Vector2(1, 15))
			polygons.append(distance_to_chicken)
			draw_colored_polygon(polygons, KICK_POLYGON_COLOR)
		else:
			reset_kick()

func reset_kick():
	drawLine = false
	change_state(GHOST_STATE.in_free_mode)
	rotation = 0
