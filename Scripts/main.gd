extends Node

@export var virus_drone_scene: PackedScene
@export var boss_scene: PackedScene

func _ready() -> void:
	$Player.hide()
	get_tree().paused = true

func _process(delta: float) -> void:
	if Game.gamestate != Game.state.PAUSE_MENU:
		if Input.is_action_just_pressed("pause_game"):
			$PauseMenu.pause()
	load_stat_menu()

func _on_menu_start_game() -> void:
	$HUD/MessageTimer.start()
	$HUD.show_message("Prepare yourself.")
	$Player.show()
	await get_tree().create_timer(2.0).timeout
	$SpawnVirusDroneTimer.start()

func _on_spawn_virus_drone_timer_timeout() -> void:
	var virus_drone = virus_drone_scene.instantiate()
	var spawn_location_x = randf_range(0, Game.screen_size.x)
	var spawn_location = Vector2(spawn_location_x, 0 )
	virus_drone.position = spawn_location
	virus_drone.set_motion(randi_range(-50, 50), randi_range(300, 375)) # Switch to drone speed
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
	print(boss.position)
	#boss.set_motion(0, 100) # Switch to drone speed
	add_child(boss)

func sudo_queue_free(node): #Child killer
	for n in node.get_children():
		node.remove_child(n)
		n.queue_free() 

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
