extends Node

const WORLD_UP = 0
const WORLD_DOWN = 1
const DEFAULT_GRAVITY = 24

var coins := 0
var totalCoins := 0
var world_orientation := WORLD_UP

var current_scene = null


func _ready():
	var root = get_tree().root
	# Using a negative index counts from the end, so this gets the last child node of `root`.
	totalCoins = get_tree().get_current_scene().get_node("Coins").get_child_count()
	print(totalCoins)
	
func reset():
	# reset score
	coins = 0
	
	# reset gravity and vector
	PhysicsServer3D.area_set_param(get_viewport().find_world_3d().space, PhysicsServer3D.AREA_PARAM_GRAVITY, DEFAULT_GRAVITY)	
	PhysicsServer3D.area_set_param(get_viewport().find_world_3d().space, PhysicsServer3D.AREA_PARAM_GRAVITY_VECTOR, Vector3(0,-1,0))	
	
	print("get_gravity()")
	print(PhysicsServer3D.area_get_param(get_viewport().find_world_3d().space, PhysicsServer3D.AREA_PARAM_GRAVITY_VECTOR))

func change_world_orientation():
	
	if world_orientation == WORLD_UP:
		world_orientation = WORLD_DOWN
		
		# Reverse the gravity vector
		PhysicsServer3D.area_set_param(get_viewport().find_world_3d().space, PhysicsServer3D.AREA_PARAM_GRAVITY_VECTOR, Vector3(0,1,0))	

	elif world_orientation == WORLD_DOWN:
		world_orientation = WORLD_UP
		PhysicsServer3D.area_set_param(get_viewport().find_world_3d().space, PhysicsServer3D.AREA_PARAM_GRAVITY_VECTOR, Vector3(0,-1,0))
