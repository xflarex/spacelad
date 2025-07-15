extends Control

signal new_game
@export var new_game_button: Button
@export var quit_button: Button

func _ready() -> void:
	visible = false
	
func load():
	get_tree().paused = true
	visible = true

func _on_new_game_button_pressed() -> void:
	Game.gamestate = Game.state.MAIN_GAME
	visible = false
	get_tree().paused = false
	new_game.emit()

func _on_quit_button_pressed() -> void:
	get_tree().root.propagate_notification(NOTIFICATION_WM_CLOSE_REQUEST)
	get_tree().quit()
