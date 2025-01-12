extends CanvasLayer

func resume() -> void:
	hide()
	get_tree().paused = false
	get_parent().game_running = true
	
func pause() -> void:
	get_tree().paused = true
	get_parent().game_running = false
	show()
	
func _on_resume_button_pressed() -> void:
	resume()

func _on_quit_button_pressed() -> void:
	get_tree().quit()
