extends Node

var skeleton_scene = preload("res://scenes/skeleton.tscn")
var rock_scene = preload("res://scenes/rock.tscn")

var obstacle_types := [skeleton_scene, rock_scene]
var obstacles : Array


const PLAYER_START_POSITION = Vector2i(72, 552)
const CAMERA_START_POSITION = Vector2i(576, 324)
const VIEWPORT = Vector2i(1152, 648)

var speed : float
var score : int
var last_obstacles 
var difficulty : int
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
	new_game()
	

func new_game():
	
	score = 0
	show_score()
	game_running = false
	get_tree().paused = false
	difficulty = 0
	
	for obstacle in obstacles:
		obstacle.queue_free()
	obstacles.clear()
	
	$Player.position = PLAYER_START_POSITION
	$Player.velocity = Vector2i(0, 0)
	$Camera2D.position = CAMERA_START_POSITION
	$Ground.position = Vector2i(0, 600)
	
	$HUD/StartLabel.show()
	$GameOver.hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if game_running:
		
		speed = START_SPEED + score / SPEED_MODIFIER
		if speed > MAX_SPEED:
			speed = MAX_SPEED
		adjust_difficulty()
		
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
			get_tree().change_scene_to_file("res://scenes/enterance_cutscene.tscn")
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
			var obstacle_height = obstacle.get_node("AnimatedSprite2D").sprite_frames.get_frame_texture("idle",0).get_height() if obstacle_type == skeleton_scene else obstacle.get_node("Sprite2D").texture.get_height()
			var obstacle_scale = obstacle.get_node("AnimatedSprite2D" if obstacle_type == skeleton_scene else "Sprite2D").scale
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
	difficulty = score / SPEED_MODIFIER
	if difficulty > MAX_DIFFICULTY:
		difficulty = MAX_DIFFICULTY

func hit_obstacle(body):
	if body.name == "Player":
		game_over()
		
		
func game_over():
	get_tree().paused = true
	game_running = false
	$GameOver.show()
