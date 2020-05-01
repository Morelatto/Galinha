extends Control

export (PackedScene) var world

onready var animation = $AnimationPlayer
onready var skip = $SkipButton
onready var skip_tween = $SkipButton/Tween

func _ready():
	# just in case the player finished the game and is returning to the title screen
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	animation.play("StoryScroll")
	skip_tween.interpolate_property(skip, "modulate", Color(1, 1, 1, 0.5), Color(1, 1, 1, 0), 2, Tween.TRANS_LINEAR, Tween.EASE_IN)
	skip_tween.start()

func _on_Play_pressed():
	get_tree().change_scene_to(world)

func _on_Quit_pressed():
	get_tree().quit()

func _input(event):
	if event.is_action_pressed("ui_cancel"):
		animation.seek(11)

func _on_SkipText_pressed():
	animation.seek(11)
	disable_skip()

func _on_AnimationPlayer_animation_finished(anim_name):
	disable_skip()

func disable_skip():
	skip_tween.stop_all()
	skip.disabled = true
	skip.visible = false
