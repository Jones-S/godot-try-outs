extends Area3D

const ROTATION_SPEED := 1.2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass
	#add_to_group("affected_by_gravity_change")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	rotate_y(deg_to_rad(ROTATION_SPEED))

func _on_body_entered(body: Node3D) -> void:
	Global.change_world_orientation()
	print('Please inform everyone on the group')
	var members = get_tree().get_nodes_in_group("affected_by_gravity_change")
	print("Group members:", members)
	get_tree().call_group("affected_by_gravity_change", "gravity_changed")
	
	# disable collecting the money twice by disabling the collision layers
	set_collision_layer_value(3, false)
	set_collision_mask_value(1, false)
	
	# Re-enable after 3 seconds
	await get_tree().create_timer(3.0).timeout
	set_collision_layer_value(3, true)
	set_collision_mask_value(1, true)
