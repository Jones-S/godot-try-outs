extends Node3D

# Variable to control the motor velocity
var force := 10000
var is_loaded := true
var initial_rock_position: Vector3

@onready var rock = $Rock  # Reference to the "Rock" node

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.
	initial_rock_position = rock.global_transform.origin
	print (initial_rock_position)
	
	add_to_group('affected_by_gravity_change')


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_trigger_area_body_entered(body: Node3D) -> void:
	
	if is_loaded:
		print('Shoot now! ☄️')
		var direction := Vector3(0, force, 0)
		$Arm.apply_central_impulse(direction)
		is_loaded = false
		
		var particles = $Rock/GPUParticles3D
		#particles.lifetime = 1.0
		particles.emitting = true
		#await get_tree().create_timer(2.0).timeout
		#particles.emitting = false
	

func gravity_changed() -> void:
	# apply a very small force to the rock, so that it starts following the new gravity vector
	rock.apply_central_impulse(Vector3(0, 0.00001, 0))


func _on_trigger_area_body_exited(body: Node3D) -> void:
	if not is_loaded:
		# reset the rocks position
		is_loaded = true
		rock.global_transform.origin = initial_rock_position
		rock.linear_velocity = Vector3.ZERO
		rock.angular_velocity = Vector3.ZERO
