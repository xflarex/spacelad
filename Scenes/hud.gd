extends CanvasLayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	update_score()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	update_score()

func update_score():
	$MarginContainer/Score.text = str(Game.score)

func show_message(text):
	$Message.text = text
	$Message.show()
	$MessageTimer.start()

func show_game_over():
	show_message("Game Over")
	await $MessageTimer.timeout
	$Message.hide()

func _on_announcement_label_timer_timeout() -> void:
	$Message.hide()
