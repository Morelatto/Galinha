extends Node2D

export (PackedScene) var world

func _on_Play_pressed():
	get_tree().change_scene_to(world)

func _on_Quit_pressed():
	get_tree().quit()
