extends Node

var coins := 0
var totalCoins := 0

var current_scene = null

func _ready():
	var root = get_tree().root
	# Using a negative index counts from the end, so this gets the last child node of `root`.
	totalCoins = get_tree().get_current_scene().get_node("Coins").get_child_count()
	print(totalCoins)

	
