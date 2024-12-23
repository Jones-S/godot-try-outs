extends RigidBody3D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	add_to_group('affected_by_gravity_change')

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func gravity_changed() -> void:
	print("Gravity inverted for ", self.name)
	# apply a very small force to the rock, so that it starts following the new gravity vector
	self.apply_central_impulse(Vector3(0, 0, 0.000001))
