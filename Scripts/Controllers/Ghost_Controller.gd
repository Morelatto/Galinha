#Ghost controller is the class that will handle the user input
#since the player actually controls the ghost, not the chicken.
extends Node2D

var drawLine = false

var initial_mouse_pos = Vector2()
var final_mouse_pos = Vector2()
#Configuration
var kick_speed = 10

#Load nodes
onready var chicken = get_parent().find_node("Chicken")
onready var camera = get_parent().find_node("Camera")

#Load resources
onready var ghost_chicken_tex =  preload("res://Sprites/ghost_maromba.png")
onready var boot_tex1 =  preload("res://Sprites/boot.png")

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
		var pos = get_global_mouse_position()
		position = pos
		
	update()

func _calculate_kick_animation(delta):
	var direction_player = position - chicken.position
	direction_player = direction_player * (kick_speed * delta)
	translate(-direction_player)
	if position.distance_to(chicken.position) < 8:
		chicken.apply_force((initial_mouse_pos - final_mouse_pos) * 20)
		change_state(GHOST_STATE.in_free_mode)
		drawLine = false

func _calculate_prepare_for_kick():
	look_at(chicken.position)
	var mouse_position = _get_camera_mouse()
	var mouse_direction = initial_mouse_pos - mouse_position
	position = chicken.position - mouse_direction

func _get_camera_mouse():
	var cameraPos = get_global_mouse_position()
	return camera.to_local(cameraPos)

func change_state(new_state):
	state = new_state
	match new_state:
		GHOST_STATE.in_free_mode:
			$StaticSprite.hide()
			$AnimatedSprite.show()
			
		GHOST_STATE.in_kick_animation:
			$StaticSprite.show()
			$AnimatedSprite.hide()
			
		GHOST_STATE.in_preparing_for_kick:
			$StaticSprite.show()
			$AnimatedSprite.hide()
			#We can add a code that everytime he kicks
			#the chicken a new object appears to kick it.
			$StaticSprite.texture = boot_tex1
			

func _input(event):
	if event.is_action_pressed("ui_mouse_action"):
		position = chicken.position
		initial_mouse_pos = _get_camera_mouse()
		change_state(GHOST_STATE.in_preparing_for_kick)
		drawLine = true
		
	if event.is_action_released("ui_mouse_action"):
		final_mouse_pos = _get_camera_mouse()
		change_state(GHOST_STATE.in_kick_animation)
		rotation = 0
		

func _draw():
	if drawLine:
		var polygons = PoolVector2Array()
		polygons.append(Vector2(5, -21))
		polygons.append(Vector2(1, 15))
		var localMouse = to_local(chicken.position)
		polygons.append(localMouse)
		var color = Color(0.058,0.735,0)
		draw_colored_polygon(polygons, color)
