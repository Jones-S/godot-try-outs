extends Area3D

const ROTATION_SPEED = 2 # Number of degrees of rotation per frame

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	rotate_y(deg_to_rad(ROTATION_SPEED))
	
func _on_body_entered(body: Node3D) -> void:
	queue_free()