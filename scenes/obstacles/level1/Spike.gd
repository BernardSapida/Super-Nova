extends Area2D

onready var spike = $Spike

export var vertical_flip = false

var touched: bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	if vertical_flip:
		spike.flip_v = true

func _on_Spike_body_entered(body):
	if body.name == "Nova":
		touched = true
	
		while touched:
			body.reduce_life(10)
			yield(get_tree().create_timer(2), "timeout") 

func _on_Spike_body_exited(body):
	if body.name == "Nova":
		touched = false
