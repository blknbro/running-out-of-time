extends Node2D

@export var game_running : bool

func _ready() -> void:
	MusicPlayer.StopSongsNow()


func the_end(body: Node2D) -> void:
	get_tree().change_scene_to_file("res://scenes/cutscene/end.tscn")
