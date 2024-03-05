#scripts: spawner_pipe
 
extends Node2D

const scn_pipe = preload("res://scenes/pipe.tscn")
const PIPE_WIDTH = 26
const GROUND_HEIGHT = 56
const OFFSET_Y = 55
const OFFSET_X = 60
const AMOUNT_TO_FILL_VIEW = 3
const pipes = [
	preload("res://sprites/pipe_red_top.png"),
	preload("res://sprites/pipe_red_bottom.png"),
	preload("res://sprites/pipe_green_top.png"),
	preload("res://sprites/pipe_green_bottom.png")
]

func _ready():
	var bird = utils.get_main_node().get_node("bird")
	if (bird):
		bird.connect("state_changed", self, "_on_bird_state_changed", [], CONNECT_ONESHOT)
	
func _on_bird_state_changed(bird):
	if bird.get_state() == bird.STATE_FLAPPING:
		yield(get_tree(), "idle_frame")
		yield(get_tree().create_timer(2.5), "timeout")
		start()

func start():
	go_init_pos()
	for i in range(AMOUNT_TO_FILL_VIEW):
		spawn_and_move()

func go_init_pos():
	randomize()
	var init_pos = position
	init_pos.x += get_viewport_rect().size.x + PIPE_WIDTH/2
	init_pos.y = rand_range(0 + OFFSET_Y, get_viewport_rect().size.y - GROUND_HEIGHT - OFFSET_Y)
	var camera = utils.get_main_node().get_node("camera")
	if camera:
		init_pos.x += camera.get_total_pos().x
	position = init_pos

func spawn_and_move():
	spawn_pipe()
	go_next_pos()
	
func spawn_pipe():
	var new_pipe = scn_pipe.instance()
	var probability = 0.002 # 0.2% chance of appearing a red pipe
	var random_number = randf()

	if random_number <= probability:
		new_pipe.get_child(0).texture = pipes[0]
		new_pipe.get_child(1).texture = pipes[1]
	else:
		new_pipe.get_child(0).texture = pipes[2]
		new_pipe.get_child(1).texture = pipes[3]

	new_pipe.position = position;
	new_pipe.connect("tree_exited", self, "spawn_and_move")
	get_node("container").add_child(new_pipe)
	pass
	
func go_next_pos():
	randomize()
	var next_pos = position
	next_pos.x += PIPE_WIDTH/2 + OFFSET_X + PIPE_WIDTH/2
	next_pos.y = rand_range(0 + OFFSET_Y, get_viewport_rect().size.y - GROUND_HEIGHT - OFFSET_Y)
	position = next_pos
	pass
