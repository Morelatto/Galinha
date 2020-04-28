extends Node2D

var scroll_speed_text = 40
var scroll_speed_background = 70
var buttons_speed = 150

onready var buttons = get_parent().find_node("Buttons")
onready var skip_button = get_parent().find_node("SkipText")
onready var text = get_parent().find_node("Story")

var resolution = Vector2()

var animating_text = true
var animating_background = false
var animating_buttons = false

func _ready():
	var width = ProjectSettings.get_setting("display/window/size/width")
	var height = ProjectSettings.get_setting("display/window/size/height")
	resolution = Vector2(width, height)
	for i in range(3):
		var sprite = get_child(i)
		var scalex = width / sprite.texture.get_size().x
		var scaley = height / sprite.texture.get_size().y
		sprite.position.y = (i * height)
		sprite.set_scale(Vector2(scalex,scaley))

func _process(delta):
	if animating_text:
		animate_text(delta)
	elif animating_background:
		animate_background(delta)
	elif animating_buttons:
		animate_buttons(delta)

func _input(event):
	if event.is_action_pressed("ui_cancel"):
		position.y = -resolution.y * 2
		text.position.y = -resolution.y
		skip_button.hide()
		animating_text = false
		animating_background = false
		animating_buttons = true

func animate_buttons(delta):
	buttons.position.x += buttons_speed * delta
	if buttons.position.x > resolution.x / 2:
		buttons.position.x = resolution.x / 2
		animating_buttons = false

func animate_text(delta):
	text.position.y -= scroll_speed_text * delta
	if text.position.y < -resolution.y / 1.8:
		animating_text = false
		animating_background = true

func animate_background(delta):
	position.y -= scroll_speed_background * delta
	if position.y < -resolution.y * 2:
		position.y = -resolution.y * 2
		skip_button.hide()
		animating_background = false
		animating_buttons = true
