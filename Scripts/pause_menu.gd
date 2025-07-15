extends Control

var pause_button_pressed = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	visible = false
	
func _process(delta: float) -> void:
	if Game.gamestate == Game.state.PAUSE_MENU:
		if Input.is_action_pressed("pause_game"):
			if pause_button_pressed == false:
				resume()
		if Input.is_action_just_released("pause_game"):
			pause_button_pressed = false

func pause():
	Game.gamestate = Game.state.PAUSE_MENU
	get_tree().paused = true
	visible = true
	pause_button_pressed == true

func resume():
	Game.gamestate = Game.state.MAIN_GAME
	pause_button_pressed = true
	visible = false
	get_tree().paused = false

func _on_resume_button_pressed() -> void:
	resume()

func _on_quit_button_pressed() -> void:
	get_tree().root.propagate_notification(NOTIFICATION_WM_CLOSE_REQUEST)
	get_tree().quit()
