extends Node2D

@export var game_running : bool

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		get_tree().change_scene_to_file("res://scenes/levels/level2.tscn")
