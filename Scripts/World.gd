extends Node3D

@onready var edge_limit : Area3D = get_node("/root/Main/Edge_Limit")

@onready var fps_label : Label = get_node("/root/Main/fps_label")

@onready var main = get_node("/root/Main/")

var nb_of_fishies : int = 150 #SET UP THE NB OF FISHES

var fish_scene : PackedScene = preload("res://Scenes/Fish.tscn")

var rayon_edge_limit : float

var timer : float = 0

func _ready():
	
	# FISH LIMIT SET UP	
	var shape_edge = edge_limit.get_node("CollisionShape3D").shape
	
	if shape_edge is SphereShape3D:
		rayon_edge_limit = shape_edge.radius
	else:
		return
	#---------------------------------------------------------------------------
	
	for i in range(nb_of_fishies):
		spawn_fish()
	
func spawn_fish():
	
	var direction = Vector3(randf_range(-1, 1), randf_range(-1, 1), randf_range(-1, 1))
	direction = direction.normalized() #CAUSE WITHOUT FISH CAN SPWAN BEYOND THE SPHERE
		
	var spawn_point : Vector3 = direction * (rayon_edge_limit / 5)
	
	var fish : Node3D = fish_scene.instantiate()
	
	main.add_child(fish) # ADD CHILD FIRST TO FORCE GODOT TO CREATE A EXISTING GLOBALS VALUES ( TO MODIFY MULTIPLE GLOBALS VALUES THEN )
	
	fish.rotation = Vector3(0, randf_range(0.0, 360.0), 0)
	fish.global_position = spawn_point
	
func _process(delta):
	
	timer += delta
	if (timer >= 0.05):
		timer = 0
		get_tree().call_group("Fish", "change_direction")

	fps_label.text = "FPS: " + str(Engine.get_frames_per_second())
	
