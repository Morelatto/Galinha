extends Node2D

export var amount = 1

onready var spike = $Spike
onready var spike_sprite = $Spike/Sprite

func _ready():
	for i in range(1, amount):
		var clone = spike.duplicate()
		clone.position.x += spike_sprite.texture.get_width() * i
		add_child(clone)

# No need to check who is the body because we're using collision layers to
# set that only the player collides with spikes
func _on_Area2D_body_entered(chicken):
	print("Spike collided with ", chicken.name)
	chicken.respawn = true
