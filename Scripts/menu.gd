extends Control
signal start_game
signal update_score
var button_released = false
var started = false
var cannon_cost = Ship.cannons * 1500
var hull_cost = Ship.hull * 3000
var thruster_cost = Ship.thrusters * 1000

@export var cannon_level_label: Label
@export var hull_level_label: Label
@export var thruster_level_label: Label
@export var cannon_level_button: Button
@export var hull_level_button: Button
@export var thruster_level_button: Button
@export var cannon_cost_label: Label
@export var hull_cost_label: Label
@export var thruster_cost_label: Label
@export var start_game_button: Button
@export var reset_stats_button: Button
@export var quit_button: Button

func _ready() -> void:
	pass
	
func _process(delta: float) -> void:
	unpause()
	
func set_levels():
	cannon_level_label.text = str(Ship.cannons)
	hull_level_label.text = str(Ship.hull)
	thruster_level_label.text = str(Ship.thrusters)

func update_costs():
	cannon_cost = Ship.cannons * 1500
	hull_cost = Ship.hull * 3000
	thruster_cost = Ship.thrusters * 1000
	
	if Ship.cannons >= Ship.max_cannons:
		print(cannon_level_button.disabled)
		cannon_level_button.disabled = true
		cannon_cost_label.text = ""
	else:
		cannon_cost_label.text = str(cannon_cost)
	if Ship.hull >= Ship.max_hull:
		hull_level_button.disabled = true
		hull_cost_label.text = ""
	else:
		hull_cost_label.text = str(hull_cost)
	if Ship.thrusters >= Ship.max_thrusters:
		thruster_level_button.disabled = true
		thruster_cost_label.text = ""
	else:
		thruster_cost_label.text = str(thruster_cost)

func resume():
	Game.gamestate = Game.state.MAIN_GAME # This needs a previous state option
	button_released = true
	hide()
	get_tree().paused = false

func unpause():
	if Game.gamestate == Game.state.PAUSE_MENU && Input.is_action_just_released("pause_game"):
		button_released = true # Pause menu keeps seeing the ESC key from the act of pausing and uses it to unpause immediately. Replace this trash hack you dumb bitch.
		
	if Game.gamestate == Game.state.PAUSE_MENU && button_released == true:
		if Input.is_action_pressed("pause_game"):
			Game.gamestate = Game.state.PAUSE_MENU
			hide()
			button_released = false
			get_tree().paused = false

func _on_quit_button_pressed() -> void:
	get_tree().root.propagate_notification(NOTIFICATION_WM_CLOSE_REQUEST)
	get_tree().quit()

func show_menu():
	update_costs()
	show()
	get_tree().paused = true
	Game.gamestate = Game.state.PAUSE_MENU
	button_released = false

func game_over():
	started = false
	start_game_button.text = "New Game"
	show_menu()

func _on_start_game_button_pressed() -> void:
	if started == false:
		Game.gamestate = Game.state.MAIN_GAME
		reset_stats()
		started = true
		button_released = true
		start_game_button.text = "Resume"
		hide()
		get_tree().paused = false
		start_game.emit()
	else:
		resume() # Start button becomes the resume button

func _on_reset_stats_button_pressed() -> void:
	reset_stats()

func reset_stats():
	Game.score = 0
	Ship.cannons = 1
	Ship.hull = 1
	Ship.thrusters = 1
	cannon_level_button.disabled = false
	hull_level_button.disabled = false
	thruster_level_button.disabled = false
	set_levels()
	update_costs()
	update_score.emit()

func _on_free_money_button_pressed() -> void:
	Game.score += 100000
	update_score.emit()

func _on_cannon_level_button_pressed() -> void:
	if Ship.cannons < Ship.max_cannons && cannon_cost <= Game.score:
		Game.score -= cannon_cost
		Ship.cannons += 1
		set_levels()
		update_costs()
		update_score.emit()

func _on_hull_level_button_pressed() -> void:
	if Ship.hull < Ship.max_hull && hull_cost <= Game.score:
		Game.score -= hull_cost
		Ship.hull += 1
		set_levels()
		update_costs()
		update_score.emit()

func _on_thruster_level_button_pressed() -> void:
	if Ship.thrusters < Ship.max_thrusters && thruster_cost <= Game.score:
		Game.score -= thruster_cost
		Ship.thrusters += 1
		set_levels()
		update_costs()
		update_score.emit()

func _on_asteroid_speed_slider_drag_ended(value_changed: bool) -> void:
	Game.asteroid_speed = $MarginContainer/ColorRect/VSplitContainer/HBoxContainer/MarginContainer2/VBoxContainer/MarginContainer/VBoxContainer/HBoxContainer/AsteroidSpeedSlider.value
	$MarginContainer/ColorRect/VSplitContainer/HBoxContainer/MarginContainer2/VBoxContainer/MarginContainer/VBoxContainer/HBoxContainer/AsteroidSpeedLabel.text = str(int(Game.asteroid_speed))


func _on_asteroid_frequency_slider_drag_ended(value_changed: bool) -> void:
	get_parent().modify_asteroid_timer($MarginContainer/ColorRect/VSplitContainer/HBoxContainer/MarginContainer2/VBoxContainer/MarginContainer2/VBoxContainer/HBoxContainer/AsteroidFrequencySlider.value)


func _on_asteroid_frequency_slider_value_changed(value: float) -> void:
	$MarginContainer/ColorRect/VSplitContainer/HBoxContainer/MarginContainer2/VBoxContainer/MarginContainer2/VBoxContainer/HBoxContainer/AsteroidFrequencyLabel.text = str($MarginContainer/ColorRect/VSplitContainer/HBoxContainer/MarginContainer2/VBoxContainer/MarginContainer2/VBoxContainer/HBoxContainer/AsteroidFrequencySlider.value)


func _on_asteroid_speed_slider_value_changed(value: float) -> void:
	$MarginContainer/ColorRect/VSplitContainer/HBoxContainer/MarginContainer2/VBoxContainer/MarginContainer/VBoxContainer/HBoxContainer/AsteroidSpeedLabel.text = str(int($MarginContainer/ColorRect/VSplitContainer/HBoxContainer/MarginContainer2/VBoxContainer/MarginContainer/VBoxContainer/HBoxContainer/AsteroidSpeedSlider.value))
