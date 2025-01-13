extends Node2D

@export var game_running : bool

func _ready() -> void:
	MusicPlayer.StopSongsNow()

func change_level(body: Node2D) -> void:
	if body.name == "Player":
		get_tree().change_scene_to_file("res://scenes/levels/level3.tscn")
