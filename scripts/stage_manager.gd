extends CanvasLayer

const GAME_STAGE = "res://stages/game_stage.tscn"
const MENU_STAGE = "res://stages/main_menu.tscn"
const SCORE_STAGE = "res://stages/high_scores.tscn"

signal stage_changed

func _ready():
	pass

func change_stage(stage_path):
	var old_layer = layer
	layer = 5
	get_node("amin").play("fade_in")
	get_node("sfx_swooshing").play()
	yield(get_node("amin"), "animation_finished")

	get_tree().change_scene(stage_path)
	layer = old_layer
	emit_signal("stage_changed")
	pass
