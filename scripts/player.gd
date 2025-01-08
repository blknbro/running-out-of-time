extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -1000.0
const GRAVITY = 2000.0


func _physics_process(delta: float) -> void:
	
	velocity.y += GRAVITY * delta
	
	if is_on_floor():
		if not get_parent().game_running:
			$AnimatedSprite2D.play("idle")
		else:
			if Input.is_action_pressed("jump"):
				velocity.y = JUMP_VELOCITY
			else:
				$AnimatedSprite2D.play("run")
	else:
		$AnimatedSprite2D.play("jump")
		
	move_and_slide()
