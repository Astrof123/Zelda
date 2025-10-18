extends Node2D

func _process(delta: float) -> void:
	change_scenes()


func _on_cliffside_exit_body_entered(body: Node2D) -> void:
	if body.has_method("player"):
		global.transition_scene = true


func change_scenes():
	if global.transition_scene == true:
		
		if global.current_scene == "cliff_side":
			get_tree().change_scene_to_file("res://scenes/Main.tscn")
			global.finish_change_scenes()
