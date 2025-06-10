extends Control
var game_paused = false
var button_released = false
signal start_game

var started = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hide()

func _process(delta: float) -> void:
	if game_paused == true && Input.is_action_just_released("pause_game"):
		button_released = true # Pause menu keeps seeing the ESC key from the act of pausing and uses it to unpause immediately. Replace this trash hack you dumb bitch.
	if game_paused == true && button_released == true:
		if Input.is_action_pressed("pause_game"):
			hide()
			game_paused = false
			button_released = false
			get_tree().paused = false

func _on_quit_button_pressed() -> void:
	get_tree().root.propagate_notification(NOTIFICATION_WM_CLOSE_REQUEST)
	get_tree().quit()

func show_menu():
	show()
	game_paused = true
	button_released = false

func _on_start_game_button_pressed() -> void:
	if started == false:
		started = true
		hide()
		#game_paused = false
		#button_released = false
		#get_tree().paused = false
		start_game.emit()
	else:
		print("Resume")
