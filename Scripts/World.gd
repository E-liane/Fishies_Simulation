extends Node3D

@onready var center_limit : Area3D = get_node("/root/Main/Center_Limit")
@onready var edge_limit : Area3D = get_node("/root/Main/Edge_Limit")

@onready var main = get_node("/root/Main/")

var nb_of_fishies : int = 1 #SET UP THE NB OF FISHES

var fish_scene : PackedScene = preload("res://Scenes/Fish.tscn")

var center : Vector3
var rayon_center_limit : float
var rayon_edge_limit : float

func _ready():
	
	# FISH LIMIT SET UP
	center = center_limit.global_transform.origin

	var shape_center = center_limit.get_node("CollisionShape3D").shape

	if shape_center is SphereShape3D:
		rayon_center_limit = shape_center.radius
	else:
		return
		
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
	
	var distance_from_the_center = randf_range(rayon_center_limit, rayon_edge_limit)
	
	var spawn_point : Vector3 = direction * distance_from_the_center
	
	var fish : Node3D = fish_scene.instantiate()
	
	main.add_child(fish) # ADD CHILD FIRST TO FORCE GODOT TO CREATE A EXISTING GLOBALS VALUES ( TO MODIFY MULTIPLE GLOBALS VALUES THEN )
	
	fish.global_rotation = Vector3(0, randf_range(0.0, 360.0), 0)
	fish.global_position = spawn_point
	
	
	print(spawn_point)
