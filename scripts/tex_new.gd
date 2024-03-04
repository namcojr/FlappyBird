extends TextureRect

func _ready():
	hide()
	game.connect("score_best_changed", self, "show")
	pass
