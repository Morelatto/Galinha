extends Node2D

func _on_Play_pressed():
	get_tree().change_scene("res://Scenes/Stages/World.tscn")
	pass


func _on_Quit_pressed():
	get_tree().quit()
