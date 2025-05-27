extends CharacterBody3D

@onready var noise := FastNoiseLite.new()

var noise_time := 0.0
var noise_offset := 0.0
@export var noise_speed := 1.0
@export var turn_amount := 1

@export var speed : float = 3.0
@export var separation_radius : int = 1
@export var alignement_radius : int = 5
@export var cohesion_radius : int = 10

@export var attract_by_center : int = 20 #LITTLE INT BIG ATTRACT
@export var fishies_influence : bool = true
@export var nb_fish_max_in_view : int = 10

var fishies_in_view : Array[Node3D] = []

@export var max_angle_deg : int = 1

func _ready():
	randomize()
	noise.seed = randi()
	noise_offset = randf_range(0.0, 1000.0)

func random_direction() -> Vector3:
	var direction := Vector3(
		noise.get_noise_3d(noise_time, 0, 0),
		noise.get_noise_3d(0, noise_time, 0),
		noise.get_noise_3d(0, 0, noise_time)
	) * turn_amount

	return direction

func _process(delta):
	noise_time += delta * noise_speed
	
	var forward = -transform.basis.z
	position += forward * speed * delta

func _on_eyes_body_entered(body):
	if (body != self and fishies_in_view.size() < nb_fish_max_in_view):
		fishies_in_view.append(body)

func _on_eyes_body_exited(body):
	fishies_in_view.erase(body)

func change_direction():
	var new_direction := Vector3.ZERO
	var forward := -global_transform.basis.z.normalized()

	for fish in fishies_in_view:
		
		var vec_distance := fish.global_position - global_position
		var distance := vec_distance.length()
		
		if (distance < separation_radius):
			new_direction += -vec_distance * 6
		elif (distance > alignement_radius and distance < cohesion_radius):
			new_direction += vec_distance * 6
		else:
			new_direction += -fish.global_transform.basis.z
		
	if new_direction == Vector3.ZERO or fishies_influence == false:
		var dir : Vector3 = (-global_transform.origin / (attract_by_center)) + (random_direction() * 2)
		var limited_dir := get_average_vector(forward, dir, max_angle_deg)
		var final_dir = global_transform.origin + limited_dir
		
		look_at(final_dir, Vector3.UP)
		return

	new_direction = new_direction.normalized() + (-global_transform.origin / (attract_by_center)) + random_direction()

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
