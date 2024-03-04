extends Node

var anim = "anim_orange"
var sprite = "anim_sprite_orange"
var animations = [
	"anim_red",
	"anim_blue",
	"anim_orange"
]
var sprites = [
	"anim_sprite_red",
	"anim_sprite_blue",
	"anim_sprite_orange"
]
	
func _ready():
	pass # Replace with function body.

func get_main_node():
	var root_node = get_tree().get_root()
	return root_node.get_child(root_node.get_child_count()-1)

func get_digits(number):
	var str_number = str(number)
	var digits = []
	for i in range(str_number.length()):
		digits.append(str_number[i].to_int())
	return digits
	pass

func get_anim():
	return anim
	pass
	
func get_sprite():
	return sprite
	pass
	
func get_bird_index():
	var birds = [
		"anim_blue",
		"anim_red",
		"anim_orange"
	]
	var bird = get_anim()	
	return birds.find(bird)

func get_random_bird():
	var arrayLength = animations.size()
	var randomIndex = randi() % arrayLength

	anim = animations[randomIndex]
	sprite = sprites[randomIndex]
	
	for i in range(0, 2):
		get_main_node().get_node("bird").get_child(i).visible = false

	get_main_node().get_node("bird").get_child(randomIndex).visible = true
pass

func set_random_background():
	var backgrounds = [
		preload("res://sprites/background_day.png"),
		preload("res://sprites/background_night.png")
	]

	var node_texture = get_main_node().get_node("background").get_child(0)
	node_texture.texture = backgrounds[randi() % 2]
	pass
	
func save_high_scores(scores):
	var file = File.new()
	file.open("user://high_scores.json", File.WRITE)
	var json_scores = JSON.print(scores)
	file.store_line(json_scores)
	file.close()

func load_high_scores():
	var file = File.new()
	if file.file_exists("user://high_scores.json"):
		file.open("user://high_scores.json", File.READ)
		var scores = file.get_line()
		file.close()
		return JSON.parse(scores).result
	else:
		var object_array = []
		for i in range(5):
			var obj = {"score": 0, "bird": 0, "time_of_day": "", "flaps": 0}
			object_array.append(obj)
		return object_array
