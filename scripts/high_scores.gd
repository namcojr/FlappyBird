extends Node2D

var birds = [
	preload("res://sprites/bird_blue_1.png"),
	preload("res://sprites/bird_red_1.png"),
	preload("res://sprites/bird_orange_1.png")
]

func _ready():
	get_node("menu").get_node("show_scores").play("slide_scores")
	var scores = utils.load_high_scores()
	var nodes = [
		"first_score",
		"second_score",
		"third_score",
		"fourth_score",
		"fifth_score"
	]

	for i in range(0, 5):
		if scores[i].score != null:
			var current_node = utils.get_main_node().get_node("menu").get_child(i + 2)
			current_node.visible = scores[i].score >= 0
			current_node.get_child(0).text = str(scores[i].score)
			current_node.get_child(1).texture = birds[scores[i].bird]
			current_node.get_child(2).text = scores[i].time_of_day.replace('-', '/')
			current_node.get_child(3).text = str(scores[i].flaps)
