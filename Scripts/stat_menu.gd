extends Control
signal stat_menu
signal next_level
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
@export var next_level_button: Button
@export var free_money_button: Button
@export var quit_button: Button
	
func set_levels():
	cannon_level_label.text = str(Ship.cannons)
	hull_level_label.text = str(Ship.hull)
	thruster_level_label.text = str(Ship.thrusters)

func update_costs():
	cannon_cost = Ship.cannons * 1000
	hull_cost = Ship.hull * 1500
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

func _on_quit_button_pressed() -> void:
	get_tree().root.propagate_notification(NOTIFICATION_WM_CLOSE_REQUEST)
	get_tree().quit()

func show_menu():
	update_costs()
	show()
	Game.gamestate = Game.state.STAT_MENU
	button_released = false

func _on_free_money_button_pressed() -> void:
	Game.score += 100000

func _on_cannon_level_button_pressed() -> void:
	if Ship.cannons < Ship.max_cannons && cannon_cost <= Game.score:
		Game.score -= cannon_cost
		Ship.cannons += 1
		set_levels()
		update_costs()

func _on_hull_level_button_pressed() -> void:
	if Ship.hull < Ship.max_hull && hull_cost <= Game.score:
		Game.score -= hull_cost
		Ship.hull += 1
		set_levels()
		update_costs()

func _on_thruster_level_button_pressed() -> void:
	if Ship.thrusters < Ship.max_thrusters && thruster_cost <= Game.score:
		Game.score -= thruster_cost
		Ship.thrusters += 1
		set_levels()
		update_costs()

func _on_next_level_button_pressed() -> void:
	Game.gamestate = Game.state.MAIN_GAME
	started = true
	button_released = true
	hide()
	get_tree().paused = false
	next_level.emit()
