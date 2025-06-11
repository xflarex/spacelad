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
	$Message.hide()

func update_score():
	$ScoreLabel.text = str(Globals.score)

func _on_message_timer_timeout():
	$Message.hide()
