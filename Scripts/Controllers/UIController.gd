extends Control

onready var egg_label = $UILayer/Control/EggLabel

func _process(delta):
	egg_label.set_text(str("x", Globals.collected_eggs))
