extends Area3D

func _on_body_entered(body):
	body.change_state("in_school")

func _on_body_exited(body):
	body.change_state("too_far")
