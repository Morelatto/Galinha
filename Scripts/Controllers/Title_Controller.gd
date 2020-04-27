extends Node2D

var scroll_speed_text = 30
var scroll_speed_background = 50
var buttons_speed = 150

onready var buttons = get_parent().find_node("Buttons")
onready var skip_button = get_parent().find_node("SkipText")
onready var text = get_parent().find_node("Story")

var animating_text = true
var animating_background = false
var animating_buttons = false

func _process(delta):
	if animating_text:
		animate_text(delta)
	elif animating_background:
		animate_background(delta)
	elif animating_buttons:
		animate_buttons(delta)
		
func _input(event):
	if event.is_action_pressed("ui_cancel"):
		position.y = -get_viewport().size.y * 2
		text.position.y = -get_viewport().size.y
		animating_text = false
		animating_background = false
		animating_buttons = true
	
func animate_buttons(delta):
	buttons.position.x += buttons_speed * delta
	if buttons.position.x > get_viewport().size.x / 2:
		buttons.position.x = get_viewport().size.x / 2
		animating_buttons = false
	
func animate_text(delta):
	text.position.y -= scroll_speed_text * delta
	if text.position.y < -get_viewport().size.y / 1.8:
		animating_text = false
		animating_background = true
		
func animate_background(delta):
	position.y -= scroll_speed_background * delta
	if position.y < -get_viewport().size.y * 2:
		position.y = -get_viewport().size.y * 2
		animating_background = false
		animating_buttons = true
