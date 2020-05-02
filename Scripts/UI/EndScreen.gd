extends Control

onready var eggs_label= $VBoxContainer/EggsLabel
onready var animation = $AnimationPlayer

func _ready():
	eggs_label.text = eggs_label.text % [
		Globals.collected_eggs,
		"" if Globals.collected_eggs == 1 else "s",
		Globals.total_eggs]
	animation.play("end")
