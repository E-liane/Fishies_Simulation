extends Area3D

func _on_body_entered(body):
	pass

func _on_body_exited(body):
	body.rotate_y(PI)
