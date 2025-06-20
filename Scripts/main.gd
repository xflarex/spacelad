extends Node

@export var asteroid_scene: PackedScene
@export var virus_drone_scene: PackedScene
var asteroid_spawn_location = Vector2.ZERO

func _ready() -> void:
	$Player.hide()
	$Menu.set_levels()
	$Menu.show_menu()

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("pause_game"):
		get_tree().paused = true
		$Menu.show_menu()

#AsteroidTimer will probably change to enemy timer
func _on_asteroid_timer_timeout() -> void:
	var asteroid = asteroid_scene.instantiate()
	var asteroidStart = randf_range(0, Game.screen_size.x)
	asteroid_spawn_location = Vector2(asteroidStart, 0 ) # Create var here instead
	asteroid.position = asteroid_spawn_location
	asteroid.set_asteroid_motion(randi_range(-50, 50), randi_range(Game.asteroid_speed, Game.asteroid_speed+75))
	add_child(asteroid)

func _on_menu_start_game() -> void:
	$HUD/MessageTimer.start()
	$HUD.show_message("Prepare yourself.")
	$Player.show()
	await get_tree().create_timer(2.0).timeout
	#$AsteroidTimer.start()
	$SpawnVirusDroneTimer.start()

func death_menu():
	$Menu.show_menu()


func _on_spawn_virus_drone_timer_timeout() -> void:
	var virus_drone = virus_drone_scene.instantiate()
	var spawn_location_x = randf_range(0, Game.screen_size.x)
	var spawn_location = Vector2(spawn_location_x, 0 )
	virus_drone.position = spawn_location
	virus_drone.set_motion(randi_range(-50, 50), randi_range(300, 375)) # Switch to drone speed
	add_child(virus_drone)
