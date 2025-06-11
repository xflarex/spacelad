extends Control
signal start_game
var game_paused = false
var button_released = false
var started = false
var cannon_cost = Ship.cannons * 1500
var hull_cost = Ship.hull * 3000
var thruster_cost = Ship.thrusters * 1000

var cannon_level_label
var hull_level_label
var thruster_level_label
var cannon_level_button
var hull_level_button
var thruster_level_button
var cannon_cost_label
var hull_cost_label
var thruster_cost_label

func _ready() -> void:
	cannon_level_label = $MarginContainer/ColorRect/VSplitContainer/HBoxContainer/MarginContainer/VBoxContainer/MarginContainer2/HBoxContainer/VBoxContainer2/MarginContainer2/CannonLevelLabel
	hull_level_label = $MarginContainer/ColorRect/VSplitContainer/HBoxContainer/MarginContainer/VBoxContainer/MarginContainer2/HBoxContainer/VBoxContainer2/MarginContainer3/HullLevelLabel
	thruster_level_label = $MarginContainer/ColorRect/VSplitContainer/HBoxContainer/MarginContainer/VBoxContainer/MarginContainer2/HBoxContainer/VBoxContainer2/MarginContainer4/ThrusterLevelLabel
	cannon_level_button = $MarginContainer/ColorRect/VSplitContainer/HBoxContainer/MarginContainer/VBoxContainer/MarginContainer2/HBoxContainer/VBoxContainer3/MarginContainer2/CannonLevelButton
	hull_level_button = $MarginContainer/ColorRect/VSplitContainer/HBoxContainer/MarginContainer/VBoxContainer/MarginContainer2/HBoxContainer/VBoxContainer3/MarginContainer3/HullLevelButton
	thruster_level_button = $MarginContainer/ColorRect/VSplitContainer/HBoxContainer/MarginContainer/VBoxContainer/MarginContainer2/HBoxContainer/VBoxContainer3/MarginContainer4/ThrusterLevelButton
	cannon_cost_label = $MarginContainer/ColorRect/VSplitContainer/HBoxContainer/MarginContainer/VBoxContainer/MarginContainer2/HBoxContainer/VBoxContainer4/MarginContainer2/CannonCostLabel
	hull_cost_label = $MarginContainer/ColorRect/VSplitContainer/HBoxContainer/MarginContainer/VBoxContainer/MarginContainer2/HBoxContainer/VBoxContainer4/MarginContainer3/HullCostLabel
	thruster_cost_label = $MarginContainer/ColorRect/VSplitContainer/HBoxContainer/MarginContainer/VBoxContainer/MarginContainer2/HBoxContainer/VBoxContainer4/MarginContainer4/ThrusterCostLabel

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
	game_paused = false
	button_released = true
	hide()
	get_tree().paused = false

func unpause():
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
	update_costs()
	show()
	get_tree().paused = true
	game_paused = true
	button_released = false

func game_over():
	started = false
	$MarginContainer/ColorRect/VSplitContainer/HBoxContainer2/MarginContainer/VBoxContainer/MarginContainer/StartGameButton.text = "New Game"
	show_menu()

func _on_start_game_button_pressed() -> void:
	if started == false:
		reset_stats()
		started = true
		game_paused = false
		button_released = true
		$MarginContainer/ColorRect/VSplitContainer/HBoxContainer2/MarginContainer/VBoxContainer/MarginContainer/StartGameButton.text = "Resume"
		hide()
		get_tree().paused = false
		start_game.emit()
	else:
		resume() # Start button becomes the resume button

func _on_reset_stats_button_pressed() -> void:
	reset_stats()

func reset_stats():
	Globals.score = 0
	Ship.cannons = 1
	Ship.hull = 1
	Ship.thrusters = 1
	cannon_level_button.disabled = false
	hull_level_button.disabled = false
	thruster_level_button.disabled = false
	set_levels()
	update_costs()
	get_parent().update_score()

func _on_free_money_button_pressed() -> void:
	get_parent().increase_score(100000)

func _on_cannon_level_button_pressed() -> void:
	if Ship.cannons < Ship.max_cannons && cannon_cost <= Globals.score:
		Globals.score -= cannon_cost
		Ship.cannons += 1
		set_levels()
		update_costs()
		get_parent().update_score()

func _on_hull_level_button_pressed() -> void:
	if Ship.hull < Ship.max_hull && hull_cost <= Globals.score:
		Globals.score -= hull_cost
		Ship.hull += 1
		set_levels()
		update_costs()
		get_parent().update_score()

func _on_thruster_level_button_pressed() -> void:
	if Ship.thrusters < Ship.max_thrusters && thruster_cost <= Globals.score:
		Globals.score -= thruster_cost
		Ship.thrusters += 1
		set_levels()
		update_costs()
		get_parent().update_score()


func _on_asteroid_speed_slider_drag_ended(value_changed: bool) -> void:
	Globals.asteroid_speed = $MarginContainer/ColorRect/VSplitContainer/HBoxContainer/MarginContainer2/VBoxContainer/MarginContainer/VBoxContainer/HBoxContainer/AsteroidSpeedSlider.value
	$MarginContainer/ColorRect/VSplitContainer/HBoxContainer/MarginContainer2/VBoxContainer/MarginContainer/VBoxContainer/HBoxContainer/AsteroidSpeedLabel.text = str(int(Globals.asteroid_speed))


func _on_asteroid_frequency_slider_drag_ended(value_changed: bool) -> void:
	pass # Replace with function body.
