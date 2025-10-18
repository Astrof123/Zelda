extends Node2D

func _ready() -> void:
	if global.game_first_loading == true:
		$Player.position.x = global.player_start_pos_x
		$Player.position.y = global.player_start_pos_y
	else:
		$Player.position.x = global.player_exit_cliffside_pos_x
		$Player.position.y = global.player_exit_cliffside_pos_y

func _process(delta: float) -> void:
	change_scene()


func _on_cliff_side_transition_body_entered(body: Node2D) -> void:
	if body.has_method("player"):
		global.transition_scene = true


func change_scene():
	if global.transition_scene == true:
		if global.current_scene == "world":
			get_tree().change_scene_to_file("res://scenes/cliff_side.tscn")
			global.game_first_loading = false
			global.finish_change_scenes()
