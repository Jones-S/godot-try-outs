extends Area3D

const ROTATION_SPEED = 2 # Number of degrees of rotation per frame
@export var hud : CanvasLayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	rotate_y(deg_to_rad(ROTATION_SPEED))
	
func _on_body_entered(body: Node3D) -> void:
	# disable collecting the money twice by disabling the collision layers
	set_collision_layer_value(3, false)
	set_collision_mask_value(1, false)
	
	print("cash money! 💰", Global.coins)
	$AnimationPlayer.play("bounce")
	
	Global.coins += 1
	if Global.coins >= Global.totalCoins:
		get_tree().change_scene_to_file("res://level_1.tscn")
	
	hud.get_node("CoinsLabel").text = str(Global.coins)

# event triggered by the Animation within coin
func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	queue_free()
