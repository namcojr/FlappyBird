extends TextureButton

func _ready():
	connect("pressed", self, "_on_pressed")
	
func _on_pressed():
	stage_manager.change_stage(stage_manager.SCORE_STAGE)
