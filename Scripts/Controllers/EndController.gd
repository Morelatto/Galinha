extends Control

var eggs_saved = 0
var eggs_total = 6

var timeCounter = 0

onready var first_text = get_child(1)
onready var second_text = get_child(2)
onready var third_text = get_child(3)
var title = load("res://Scenes/Stages/Title2.tscn")

var eggs_text = ""
var shown_second_text = false

func _ready():
	eggs_saved = Globals.eggs_collected

func _process(delta):
	timeCounter += delta
	if timeCounter > 3:
		first_text.show()
	if !shown_second_text and timeCounter > 5:
		shown_second_text = true
		eggs_text = str("Collected ", str(eggs_saved), " eggs \nFrom a total of ", str(eggs_total))
		second_text.get_child(0).set_text(eggs_text)
		second_text.show()
	if timeCounter > 8:
		third_text.show()
	if timeCounter > 20:
		get_tree().change_scene_to(title)
