extends Control

onready var egg_text = get_child(0).get_child(0).get_child(0)
onready var chicken_ui = $UILayer/ProgressBar/ChickenUI
onready var stages_ui = $UILayer/ProgressBar/Stages

var egg_quantity = 0
var stages = []

func _ready():
	for stage in stages_ui.get_children():
		stages.append(stage)

func add_egg():
	egg_quantity += 1
	egg_text.set_text(str("x", egg_quantity))
	Globals.eggs_collected = egg_quantity


func _on_advanced_level():
	var node = stages.pop_front()
	chicken_ui.global_position.x = node.global_position.x
