extends CharacterBody2D
signal game_over

@export var Bullet : PackedScene
var target = Vector2.ZERO
var ready_to_fire = true

func _ready() -> void:
	Game.screen_size = get_viewport_rect().size
	start()
	
func _physics_process(delta: float) -> void:
	if Game.gamestate != Game.state.PAUSE_MENU:
		var velocity = Vector2.ZERO
		velocity = player_movement(velocity, delta)
		player_movement_animation(velocity)
		$Node2D.look_at(target)
		player_fire()
		Ship.player_node = self

func _input(event: InputEvent) -> void:
	target = get_viewport().get_mouse_position()

func start():
	position.x = Game.screen_size.x / 2
	position.y = Game.screen_size.y * 0.75
	$CollisionShape2D.disabled = false
	$Shield.hide()

func player_movement(velocity, delta):
	if Ship.hull > 0: # Check if still alive first
		if Input.is_action_pressed(("move_left")):
			velocity.x -= 1
		if Input.is_action_pressed(("move_right")):
			velocity.x += 1
		if Input.is_action_pressed(("move_up")):
			velocity.y -= 1
		if Input.is_action_pressed(("move_down")):
			velocity.y += 1
	
	if velocity.length() > 0: # Normalize diagonals
		velocity = velocity.normalized() * 20
	
	var collision = move_and_collide(velocity)
	if collision:
		if collision.get_collider().is_in_group("enemies"):
			print(collision.get_collider())
			collision.get_collider().enemy_death()
			been_shot()
	position = position.clamp(Vector2.ZERO, Game.screen_size)
	
	return velocity

func player_movement_animation(velocity): # This will probably look better as sprites
	if Ship.hull > 0:
		if velocity.x == 0:
			$AnimatedSprite2D.play("move_up")
		elif velocity.x < 0:
			$AnimatedSprite2D.play("move_left")
		elif velocity.x > 0:
			$AnimatedSprite2D.play("move_right")

func player_fire():
	if Input.is_action_pressed("fire") && ready_to_fire == true:
		var b = Bullet.instantiate()
		owner.add_child(b)
		b.transform = $Node2D/AnimatedSprite2D2/Muzzle00.global_transform
		$CannonTimer.start()
		ready_to_fire = false

func _on_body_entered(body: Node2D) -> void:
	been_shot()
	
func been_shot():
	Ship.hull -= 1
	if Ship.hull <= 0:
		player_death()
		# Shield breaking animation here
	else:
		$Shield.show()
		$Shield.play()
	

func player_death():
	$Node2D/AnimatedSprite2D2.hide()
	$AnimatedSprite2D.animation = "death"
	$AnimatedSprite2D.play()
	$CollisionShape2D.set_deferred("disabled", true)
	$DeathTimer.start()
	Game.gamestate = Game.state.GAME_OVER

func _on_death_timer_timeout() -> void:
	hide()
	$CollisionShape2D.disabled = false
	#get_parent().death_menu()
	game_over.emit()
	get_tree().paused = true

func _on_cannon_timer_timeout() -> void:
	ready_to_fire = true

func _on_shield_animation_finished() -> void:
	$Shield.hide()

func load_stat_menu():
	%StatMenu.set_visible(true)
