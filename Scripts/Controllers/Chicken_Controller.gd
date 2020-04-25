extends RigidBody2D
var pos1 = Vector2(0,0)
var pos2 = Vector2(0,0)
#func _integrate_forces(state):
#	if Input.is_action_just_pressed("ui_mouse_action"):
#		var force_direction = Vector2(10,-10)
#		var force = 100
#		add_force(Vector2(1,1), force * force_direction)

func apply_force(direction):
	apply_central_impulse(direction)

#func _on_Chicken_mouse_entered():
#	if Input.is_action_just_pressed("ui_mouse_action"):
#		var force_direction = Vector3(0,0,1)
#		var force = 100
#		add_force(global_position, force * force_direction)
#	pass # Replace with function body.
