extends CharacterBody3D

@onready var noise := FastNoiseLite.new()

var noise_time := 0.0
var noise_offset := 0.0
@export var noise_speed := 1.0

@export var speed : float
@export var dispertion : int #LITTLE INT BIG DISPerTION
@export var attract_by_center : int #LITTLE INT BIG ATTRACT
@export var fishies_influence : bool

var state : String = "in_school" # "in_school", "too_far", "too_close"

var fishies_in_view : Array[Node3D] = []

@export var max_angle_deg : int

func _ready():
	randomize()
	noise.seed = randi()
	noise_offset = randf_range(0.0, 10000.0)

func _process(delta):
	noise_time += delta * noise_speed

	var forward = -transform.basis.z
	position += forward * speed * delta

func change_state(new_state : String):
	state = new_state

func _on_eyes_body_entered(body):
	if (body != self and fishies_in_view.size() < 2):
		fishies_in_view.append(body)

func _on_eyes_body_exited(body):
	fishies_in_view.erase(body)

func random_direction() -> Vector3:
		var direction := Vector3(
		noise.get_noise_3d(noise_time, 0, 0),
		noise.get_noise_3d(0, noise_time, 0),
		noise.get_noise_3d(0, 0, noise_time)
	).normalized()
		return direction

func change_direction():
	var new_direction := Vector3.ZERO
	var forward := -global_transform.basis.z.normalized()

	for fish in fishies_in_view:
		new_direction += -fish.global_transform.basis.z
		
	if new_direction == Vector3.ZERO or fishies_influence == false:
		var dir : Vector3 = (random_direction() / (dispertion * 2)) + (-global_transform.origin / (attract_by_center * 10))
		var limited_dir := get_average_vector(forward, dir, max_angle_deg)
		var final_dir = global_transform.origin + limited_dir
		
		look_at(final_dir, Vector3.UP)
		return

	new_direction = new_direction.normalized() + (-global_transform.origin / (attract_by_center * 10)) + (random_direction() / dispertion)

	var limited_dir := get_average_vector(forward, new_direction, max_angle_deg)

	var final_dir = global_transform.origin + limited_dir

	look_at(final_dir, Vector3.UP)
	
	
func get_average_vector(vec1 : Vector3, vec2 : Vector3, max_angle) -> Vector3:
	
	var angle = vec1.angle_to(vec2)

	var max_rad = deg_to_rad(max_angle)
	var t = 1.0
	if angle > max_rad:
		t = max_rad / angle
	
	return (vec1.slerp(vec2, t).normalized())

func _on_navigation_agent_3d_velocity_computed(safe_velocity):
	velocity = velocity.move_toward(safe_velocity, 1)
	move_and_slide()
