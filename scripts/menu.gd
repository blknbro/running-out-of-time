extends Control

var jungle_music : OvaniSong = load("res://assets/sounds/music/background_music_jungle.tres")

func _ready() -> void:
	MusicPlayer.QueueSong(jungle_music)
	MusicPlayer.Volume = -10
	MusicPlayer.FadeIntensity(1, 10)


func _on_start_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/levels/level1.tscn")

func _on_quit_button_pressed() -> void:
	get_tree().quit()
