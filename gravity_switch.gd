extends Area3D

const ROTATION_SPEED := 1.2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	add_to_group("affected_by_gravity_change")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	rotate_y(deg_to_rad(ROTATION_SPEED))

func _on_body_entered(body: Node3D) -> void:
	Global.change_world_orientation()
	print('Please inform everyone on the group')
	var members = get_tree().get_nodes_in_group("affected_by_gravity_change")
	print("Group members:", members)
	get_tree().call_group("affected_by_gravity_change", "gravity_changed")

func gravity_changed() -> void:
	print("Gravity inverted for ", self.name)
