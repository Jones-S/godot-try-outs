extends CharacterBody3D


const SPEED = 5.0
const JUMP_VELOCITY = 10

var xform : Transform3D

func _physics_process(delta: float) -> void:
	# rotate cam
	if Input.is_action_just_pressed("cam_left"):
		$Camera_Controller.rotate_y(deg_to_rad(30))
	
	if Input.is_action_just_pressed("cam_right"):
		$Camera_Controller.rotate_y(deg_to_rad(-30))
	
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
	
	# new Vector3 direction, taking user arrows and camera rotation into account
	var direction = ($Camera_Controller.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	# rotate character mesh to orient away from camera
	if input_dir != Vector2(0,0):
		$MeshInstance3D.rotation_degrees.y = $Camera_Controller.rotation_degrees.y - rad_to_deg(input_dir.angle()) + -90
		
	# rotate character to align with floor
	if is_on_floor() and input_dir != Vector2(0,0): # check if on floor and if is moving
		align_with_floor($RayCast3D.get_collision_normal())
		global_transform = global_transform.interpolate_with(xform, 0.3)
	elif not is_on_floor():
		align_with_floor(Vector3.UP)
		global_transform = global_transform.interpolate_with(xform, 0.3)
	
	# update velocity and move character
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
	move_and_slide()
	
	# make camera controller match position of myself
	# needs to be lower than move and slide so we dont have a lag
	$Camera_Controller.position = lerp($Camera_Controller.position, position, 0.15)
	
	
func align_with_floor(floor_normal):
	xform = global_transform
	xform.basis.y = floor_normal
	xform.basis.x = -xform.basis.z.cross(floor_normal)
	xform.basis = xform.basis.orthonormalized()
