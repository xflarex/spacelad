extends Node

@export var virus_drone_scene: PackedScene
@export var boss_scene: PackedScene

func _ready() -> void:
	$Player.hide()
	get_tree().paused = true

func _process(delta: float) -> void:
	pause_game()
	load_stat_menu()
	
func pause_game():
	if Game.gamestate != Game.state.PAUSE_MENU:
		if Input.is_action_just_pressed("pause_game"):
			$PauseMenu.pause()

func start_game():
	$HUD/MessageTimer.start()
	$HUD.show_message("Prepare yourself.")
	$Player.show()
	await get_tree().create_timer(2.0).timeout
	$SpawnVirusDroneTimer.start()

func _on_menu_start_game() -> void:
	start_game()

func _on_spawn_virus_drone_timer_timeout() -> void:
	var virus_drone = virus_drone_scene.instantiate()
	var spawn_location_x = randf_range(0, Game.screen_size.x)
	var spawn_location = Vector2(spawn_location_x, 0 )
	virus_drone.position = spawn_location
	virus_drone.set_motion() # Switch to drone speed
	add_child(virus_drone)

func _on_level_timer_timeout() -> void:
	$HUD.show_message("well shit.")
	$SpawnVirusDroneTimer.stop()
	load_boss()

func load_boss():
	var boss = boss_scene.instantiate()
	var spawn_location_x = Game.screen_size.x / 2
	var spawn_location = Vector2(spawn_location_x, -1000 )
	boss.position = spawn_location
	add_child(boss)

func load_stat_menu():
	if Game.gamestate == Game.state.STAT_MENU:
		$StatMenu.show_menu()

func _on_start_menu_start_game() -> void:
	$HUD/MessageTimer.start()
	$HUD.show_message("Prepare yourself.")
	$Player.show()
	await get_tree().create_timer(2.0).timeout
	$SpawnVirusDroneTimer.start()

func _on_player_game_over() -> void:
	$DeathMenu.load()

func _on_stat_menu_next_level() -> void:
	$HUD/MessageTimer.start()
	$HUD.show_message("Prepare yourself.")
	$Player.show()
	await get_tree().create_timer(2.0).timeout
	$SpawnVirusDroneTimer.start()
	$LevelTimer.start()


func _on_death_menu_new_game() -> void:
	get_tree().call_group("enemies", "queue_free")
	get_tree().call_group("boss", "queue_free")
	start_game()
	$HUD.show_message("Prepare yourself.")
	$SpawnVirusDroneTimer.stop()
	$LevelTimer.stop()
	$Player.start()
	await get_tree().create_timer(2.0).timeout
	$SpawnVirusDroneTimer.start()
	$LevelTimer.start()
