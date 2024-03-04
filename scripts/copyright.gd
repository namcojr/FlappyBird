extends TextureRect

func _ready():
	var timer = utils.get_main_node().get_child(1)
	timer.start()
	yield(timer, "timeout")
	stage_manager.change_stage(stage_manager.MENU_STAGE)
