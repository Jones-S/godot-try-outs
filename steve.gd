extends CharacterBody3D

var xform : Transform3D

var speed
const WALK_SPEED = 5.0
const SPRINT_SPEED = 8.0
const JUMP_VELOCITY = 12
const SENSITIVITY = 0.004

#fov variables
const BASE_FOV = 75.0
const FOV_CHANGE = 1.5

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = 9.8
var jump_direction = 1


@onready var pivot = $CamOrigin
@onready var camera = $CamOrigin/SpringArm3D/Camera3D


func _ready():
	add_to_group('affected_by_gravity_change')
	gravity = PhysicsServer3D.area_get_param(get_viewport().find_world_3d().space, PhysicsServer3D.AREA_PARAM_GRAVITY)
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)


func _unhandled_input(event):
	if event is InputEventMouseMotion:
		rotate_y((-event.relative.x) * jump_direction * SENSITIVITY)
		pivot.rotate_x(-event.relative.y * SENSITIVITY)
		pivot.rotation.x = clamp(pivot.rotation.x, deg_to_rad(-90), deg_to_rad(45))

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle Jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		print("Jump")
		velocity.y = JUMP_VELOCITY * jump_direction
	
	# Handle Sprint.
	if Input.is_action_pressed("sprint"):
		speed = SPRINT_SPEED
	else:
		speed = WALK_SPEED
	
	if Input.is_action_just_pressed("sprint"):
		print (pivot.transform.basis)
		print (transform.basis)

	# Get the input direction and handle the movement/deceleration.
	var input_dir := Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
	
	
	# rotate character to align with floor
	#if is_on_floor() and input_dir != Vector2(0,0): # check if on floor and if is moving
		#align_with_floor($RayCast3D.get_collision_normal())
		#global_transform = global_transform.interpolate_with(xform, 0.3)
	#elif not is_on_floor():
		#align_with_floor(Vector3.UP)
		#global_transform = global_transform.interpolate_with(xform, 0.3)

	
	# change moving direction to where the pivot is facing.
	var direction = (pivot.transform.basis * transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	if is_on_floor():
		if direction:
			velocity.x = direction.x * speed
			velocity.z = direction.z * speed
		else:
			velocity.x = lerp(velocity.x, direction.x * speed, delta * 7.0)
			velocity.z = lerp(velocity.z, direction.z * speed, delta * 7.0)
	else:
		velocity.x = lerp(velocity.x, direction.x * speed, delta * 3.0)
		velocity.z = lerp(velocity.z, direction.z * speed, delta * 3.0)
	
	
	# FOV
	var velocity_clamped = clamp(velocity.length(), 0.5, SPRINT_SPEED * 2)
	var target_fov = BASE_FOV + FOV_CHANGE * velocity_clamped
	camera.fov = lerp(camera.fov, target_fov, delta * 8.0)
	
	move_and_slide()

func align_with_floor(floor_normal):
	xform = global_transform
	xform.basis.y = floor_normal
	xform.basis.x = -xform.basis.z.cross(floor_normal)
	xform.basis = xform.basis.orthonormalized()


func _on_fall_zone_body_entered(body: Node3D) -> void:
	get_tree().change_scene_to_file("res://level_1.tscn") # go to top level of game (gettree) and then get the level1 scene
	
	
func gravity_changed() -> void:
	self.rotate(Vector3(1, 0, 0), deg_to_rad(180))
	#$Head/Camera3D.rotate_object_local(Vector3(1, 0, 0), deg_to_rad(180))


	jump_direction = -jump_direction
	set_up_direction(Vector3(0,jump_direction,0))
	velocity.y = 1
	move_and_slide()
	
