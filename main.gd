extends Node
@export var asteroid_scene: PackedScene
var score
var screen_size
var asteroid_spawn_location = Vector2.ZERO

func game_over() -> void:
	$AsteroidTimer.stop()
	$HUD.show_game_over()

func new_game() -> void:
	score = 0
	$Player.start($StartPosition.position)
	#$Player.show()
	$StartTimer.start()
	update_score(score)
	$HUD.show_message("Prepare yourself.")
	$Player.pause_status = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	screen_size = $Player.screen_size
	$Menu.show_menu()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
		if Input.is_action_just_pressed("pause_game"):
			get_tree().paused = true
			$Menu.show_menu()

func _on_start_timer_timeout() -> void:
	$AsteroidTimer.start()

func _on_asteroid_timer_timeout() -> void:
	var asteroid = asteroid_scene.instantiate()
	var asteroidStart = randf_range(0, screen_size.x)
	
	asteroid_spawn_location = Vector2(asteroidStart, 0)
	asteroid.position = asteroid_spawn_location
	asteroid.set_asteroid_motion(randi_range(-20, 20), randi_range(200, 275))
	
	add_child(asteroid)

func update_score(newScore):
	$HUD.update_score(newScore)

func increase_score(points):
	score += points
	update_score(score)
