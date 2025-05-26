extends CharacterBody3D

@onready var noise := FastNoiseLite.new()

var noise_time := 0.0
var noise_offset := 0.0
@export var noise_speed := 1.0
@export var turn_amount := 0.3 # Plus haut = tourne plus

@export var speed : float

var state : String = "in_school" # "in_school", "too_far", "too_close"

var fishies_in_view : Array[Node3D] = []

var max_angle_deg : int = 1

func _ready():
	randomize()
	noise.seed = randi()
	noise_offset = randf_range(0.0, 1000.0)

func _process(delta):
	noise_time += delta * noise_speed

	var forward = -transform.basis.z
	position += forward * speed * delta

func change_state(new_state : String):
	state = new_state

func _on_eyes_body_entered(body):
	if (body != self and fishies_in_view.size() < 5):
		fishies_in_view.append(body)

func _on_eyes_body_exited(body):
	if (body != self):
		fishies_in_view.erase(body)


func _on_timer_timeout():
	var direction := Vector3(
		noise.get_noise_3d(noise_time, 0, 0),
		noise.get_noise_3d(0, noise_time, 0),
		noise.get_noise_3d(0, 0, noise_time)
	).normalized()
	
	var new_direction : Vector3 = Vector3(0, 0, 0)
	
	for fish_in_view in fishies_in_view:
		new_direction += -fish_in_view.transform.basis.z
	
	if (new_direction == Vector3.ZERO):
		look_at(global_transform.origin + direction, Vector3.UP)
		return
	
	var angle = acos(-transform.basis.z.normalized().dot(new_direction))
	var max_angle = deg_to_rad(max_angle_deg)
	
	while (angle > max_angle):
		new_direction = new_direction.normalized() + -transform.basis.z.normalized()
		angle = acos(-transform.basis.z.normalized().dot(new_direction))
	
	look_at(new_direction + direction, Vector3.UP)
