extends Control

var jungle_music : OvaniSong = load("res://assets/sounds/music/background_music_jungle.tres")
var temple_music : OvaniSong = load("res://assets/sounds/music/background_music_temple.tres")
var escape_music : OvaniSong = load("res://assets/sounds/music/background_music_escape.tres")
var end_music : OvaniSong = load("res://assets/sounds/music/background_music_end.tres")


func _ready() -> void:
	MusicPlayer.QueueSong(jungle_music)
	MusicPlayer.QueueSong(escape_music)
	MusicPlayer.QueueSong(temple_music)
	MusicPlayer.QueueSong(end_music)
	MusicPlayer.Volume = -10
	MusicPlayer.FadeIntensity(1, 10)


func _on_start_button_pressed() -> void:
	MusicPlayer.StopSongsNow()
	get_tree().change_scene_to_file("res://scenes/cutscene/intro_cutscene.tscn")

func _on_quit_button_pressed() -> void:
	get_tree().quit()
