extends Control

export (PackedScene) var world

func _ready():
	$AnimationPlayer.play("StoryScroll")

func _on_Play_pressed():
	get_tree().change_scene_to(world)

func _on_Quit_pressed():
	get_tree().quit()
