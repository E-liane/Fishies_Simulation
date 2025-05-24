extends CharacterBody3D

@export var speed : float

var state : String = "in_school" # "in_school", "too_far", "too_close"

func _process(delta):
	var forward = transform.basis.x
	position += forward * speed * delta
	
	if (state == "too_far"):
		position = position - position.normalized() / 10
	elif (state == "too_close"):
		position = position + position.normalized() / 10

func change_state(new_state : String):
	state = new_state
	print(state)
