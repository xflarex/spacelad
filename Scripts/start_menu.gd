extends Control
@export var start_game_button: Button
@export var quit_button: Button
signal start_game

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Game.screen_size = get_viewport().size # This needs to be part of a screensize changed check
	print(Game.screen_size)

func _on_start_game_button_pressed() -> void:
	Game.gamestate = Game.state.MAIN_GAME
	visible = false
	get_tree().paused = false
	start_game.emit()

func _on_quit_button_pressed() -> void:
	get_tree().root.propagate_notification(NOTIFICATION_WM_CLOSE_REQUEST)
	get_tree().quit()
