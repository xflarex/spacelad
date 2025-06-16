extends Node

@export var asteroid_scene: PackedScene
var asteroid_spawn_location = Vector2.ZERO

func _ready() -> void:
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
	asteroid_spawn_location = Vector2(asteroidStart, 0 )
	asteroid.position = asteroid_spawn_location
	asteroid.set_asteroid_motion(randi_range(-50, 50), randi_range(Game.asteroid_speed, Game.asteroid_speed+75))
	add_child(asteroid)

func _on_menu_start_game() -> void:
	$HUD/MessageTimer.start()
	await get_tree().create_timer(2.0).timeout
	$AsteroidTimer.start()

func death_menu():
	$Menu.show_menu()
