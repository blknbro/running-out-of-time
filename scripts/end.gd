extends Node

var end_music : OvaniSong = load("res://assets/sounds/music/background_music_end.tres")



const PLAYER_START_POSITION = Vector2i(72, 552)
const CAMERA_START_POSITION = Vector2i(576, 324)
const VIEWPORT = Vector2i(1152, 648)

var speed : float
var score : int
const SCORE_MODIFIER : int = 10
const START_SPEED : float = 10.0
const SPEED_MODIFIER : int = 25000
const MAX_SPEED : int = 13
const MAX_DIFFICULTY : int = 2

var screen_size : Vector2i
var ground_height : int
var game_running : bool

func _ready() -> void:
	screen_size = get_window().size
	var tile_size = $Ground/TileMapLayer.tile_set.tile_size
	ground_height = $Ground/TileMapLayer.get_used_rect().size.y * tile_size.y
	$GameOver/Button.pressed.connect(self.new_game)
	$PauseMenu/Panel/VBoxContainer/RestartButton.pressed.connect(self.new_game)
	new_game()
	

func new_game():
	
	score = 0
	game_running = true
	get_tree().paused = false
	
	reset_music()
	
	$Player.position = PLAYER_START_POSITION
	$Player.velocity = Vector2i(0, 0)
	$Camera2D.position = CAMERA_START_POSITION
	$Ground.position = Vector2i(0, 600)
	
	$GameOver.hide()
	$PauseMenu.hide()
	
func _physics_process(delta: float) -> void:
	speed = START_SPEED + score / SPEED_MODIFIER
	if speed > MAX_SPEED:
		speed = MAX_SPEED
	score += speed
	$Player.position.x += speed
	$Camera2D.position.x += speed
	
	
	if $Camera2D.position.x - $Ground.position.x > screen_size.x * 2:
		$Ground.position.x += screen_size.x


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	test_esc()
	
		
func test_esc():
	if Input.is_action_pressed("escape") and !get_tree().paused and game_running:
		$PauseMenu.pause()
	elif Input.is_action_pressed("escape") and get_tree().paused and game_running:
		$PauseMenu.resume()
		
func reset_music():
	MusicPlayer.Intensity = 0
	MusicPlayer.QueueSong(end_music)
	MusicPlayer.FadeIntensity(1, 10)

func game_over():
	$Player.play_hurt()
	MusicPlayer.StopSongsNow()
	get_tree().paused = true
	game_running = false
	$GameOver.show()
