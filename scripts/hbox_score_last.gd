extends HBoxContainer

const sprite_number = [
	preload("res://sprites/number_middle_0.png"),
	preload("res://sprites/number_middle_1.png"),
	preload("res://sprites/number_middle_2.png"),
	preload("res://sprites/number_middle_3.png"),
	preload("res://sprites/number_middle_4.png"),
	preload("res://sprites/number_middle_5.png"),
	preload("res://sprites/number_middle_6.png"),
	preload("res://sprites/number_middle_7.png"),
	preload("res://sprites/number_middle_8.png"),
	preload("res://sprites/number_middle_9.png")
]

signal counter_finished
func _ready():
	var anim = utils.get_main_node().get_node("hud/con_instruction/anim")
	yield(anim, "animation_finished")
	count_to_score()
	store_and_save_scores()
	pass	

func count_to_score():
	var lerp_time 		= 0 
	var lerp_duration 	= 0.5
	while lerp_time < lerp_duration and game.score_current > 0:
		lerp_time += get_process_delta_time()
		lerp_time = min (lerp_time, lerp_duration)
		var percent = lerp_time/lerp_duration
		set_number(int(lerp(0, game.score_current, percent)))
		
		yield(get_tree(), "idle_frame")
	game.score_best = game.score_current
	emit_signal("counter_finished")
	pass
	
func set_number(num):
	for child in get_children():
		child.free()
	for digit in utils.get_digits(num):
		var texture_rect = TextureRect.new()
		texture_rect.set_texture(sprite_number[digit])
		add_child(texture_rect)
	pass

func store_and_save_scores():
	var scores = utils.load_high_scores()

	var date = OS.get_date()
	var new_score = {
		"score": game.score_current, 
		"bird": utils.get_bird_index(), 
		"time_of_day": format_date(date), 
		"flaps": game.flaps
	}
	insert_score(scores, new_score)

func insert_score(scores, new_score) -> void:
	scores.append(new_score)
	scores.sort_custom(self, "compareScores")

	if scores.size() > 5:
		scores.pop_back()

	utils.save_high_scores(scores)

func compareScores(a, b):
	return a["score"] > b["score"]

func format_date(date):
	var day = String(date.day).pad_zeros(2)
	var month = String(date.month).pad_zeros(2)
	var year = String(date.year).right(2)
	return day + "-" + month + "-" + year
