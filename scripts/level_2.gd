extends Node

var green_slime = preload("res://scenes/game_elements/green_slime.tscn")
var purple_slime = preload("res://scenes/game_elements/purple_slime.tscn")
var barrel_scene = preload("res://scenes/game_elements/barrel.tscn")

var temple_music : OvaniSong = load("res://assets/sounds/music/background_music_temple.tres")

var obstacle_types := [green_slime, purple_slime, barrel_scene]
var obstacles : Array


const PLAYER_START_POSITION = Vector2i(72, 552)
const CAMERA_START_POSITION = Vector2i(576, 324)
const VIEWPORT = Vector2i(1152, 648)

var speed : float
var score : int
var last_obstacles 
var difficulty : int
const SCORE_MODIFIER : int = 10
const START_SPEED : float = 13.0
const SPEED_MODIFIER : int = 10000
const MAX_SPEED : int = 14
const MAX_DIFFICULTY : int = 4

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
	show_score()
	game_running = false
	get_tree().paused = false
	difficulty = 1
	
	reset_music()
	
	for obstacle in obstacles:
		obstacle.queue_free()
	obstacles.clear()
	
	$Player.position = PLAYER_START_POSITION
	$Player.velocity = Vector2i(0, 0)
	$Camera2D.position = CAMERA_START_POSITION
	$Ground.position = Vector2i(0, 600)
	
	$HUD/StartLabel.show()
	$GameOver.hide()
	$PauseMenu.hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if game_running:
		
		speed = START_SPEED + score / SPEED_MODIFIER
		if speed > MAX_SPEED:
			speed = MAX_SPEED
		adjust_difficulty()
		test_esc()
		
		generate_obstacles()
		
		$Player.position.x += speed
		$Camera2D.position.x += speed
		
		score += speed
		show_score()
		
		if $Camera2D.position.x - $Ground.position.x > screen_size.x * 2:
			$Ground.position.x += screen_size.x
			
		for obstacle in obstacles:
			if obstacle.position.x < ($Camera2D.position.x - screen_size.x):
				remove_obstacle(obstacle)
		if (score / SCORE_MODIFIER) >= 10000 and $Player.is_on_floor():
			get_tree().change_scene_to_file("res://scenes/cutscene/enterance_cutscene.tscn")
	else: 
		if Input.is_action_pressed("jump"):
			game_running = true
			$HUD/StartLabel.visible = false
func show_score():
	$HUD/ScoreLabel.text = "SCORE: " + str(score / SCORE_MODIFIER)

func generate_obstacles():
	if obstacles.is_empty() or last_obstacles.position.x < score + randi_range(100, 500):
		var max_obstacles = difficulty + 1
		for i in range(randi() % max_obstacles + 1):
			var obstacle_type = obstacle_types.pick_random()
			var obstacle = obstacle_type.instantiate()
			var obstacle_height = obstacle.get_node("AnimatedSprite2D").sprite_frames.get_frame_texture("idle",0).get_height() if obstacle_type == green_slime or obstacle_type == purple_slime else obstacle.get_node("Sprite2D").texture.get_height()
			var obstacle_scale = obstacle.get_node("AnimatedSprite2D" if obstacle_type == green_slime or obstacle_type == purple_slime else "Sprite2D").scale
			var obstacle_x : int = VIEWPORT.x + score + 100 + (i * 100)
			var obstacle_y : int = VIEWPORT.y - ground_height - ( obstacle_height * obstacle_scale.y / 2 ) + 5
			last_obstacles = obstacle
			add_obstacle(obstacle, obstacle_x, obstacle_y)

func add_obstacle(obstacle, x, y):
	obstacle.position = Vector2i(x, y)
	obstacle.body_entered.connect(hit_obstacle)
	add_child(obstacle)
	obstacles.append(obstacle)
	
func remove_obstacle(obstacle):
	obstacle.queue_free()
	obstacles.erase(obstacle)
	
func adjust_difficulty():
	difficulty = score / SPEED_MODIFIER + 1
	if difficulty > MAX_DIFFICULTY:
		difficulty = MAX_DIFFICULTY

func hit_obstacle(body):
	if body.name == "Player":
		game_over()
		
func test_esc():
	if Input.is_action_pressed("escape") and !get_tree().paused and game_running:
		$PauseMenu.pause()
	elif Input.is_action_pressed("escape") and get_tree().paused and game_running:
		$PauseMenu.resume()

func reset_music():
	MusicPlayer.QueueSong(temple_music)
	MusicPlayer.FadeIntensity(1, 10)

func game_over():
	$Player/Hurt.playing = true
	MusicPlayer.StopSongsNow()
	get_tree().paused = true
	game_running = false
	$GameOver.show()
