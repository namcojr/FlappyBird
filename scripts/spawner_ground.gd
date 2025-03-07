extends Node2D
const GROUND_WIDTH = 168
const scn_ground = preload("res://scenes/ground.tscn")
const AMOUNT_TO_FILL_VIEW = 2

func _ready():
	for i in range(AMOUNT_TO_FILL_VIEW):
		spawn_ground()

func spawn_ground():
	var new_ground = scn_ground.instance()
	new_ground.position = position
	new_ground.connect("tree_exited", self, "spawn_ground")
	position += Vector2(GROUND_WIDTH, 0)
	get_node("container").add_child(new_ground)
