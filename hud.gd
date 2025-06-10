extends CanvasLayer
signal start_games
signal call_update_score


func show_message(text):
	$Message.text = text
	$Message.show()
	$MessageTimer.start()

func show_game_over():
	show_message("Game Over")
	await $MessageTimer.timeout
	
	$Message.text = "To Battle!"
	$Message.show()
	
	await get_tree().create_timer(1.0).timeout
	$StartButton.show()

func update_score(score):
	$StartButton.hide()
	$ScoreLabel.text = str(score)

func _on_message_timer_timeout():
	$Message.hide()

func _on_start_button_pressed() -> void:
	$StartButton.hide()
	start_games.emit()
