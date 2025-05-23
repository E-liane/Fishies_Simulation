extends StaticBody3D

@export var speed : float

func _process(delta):
	var forward = transform.basis.x
	position += forward * speed * delta
