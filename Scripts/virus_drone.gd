extends RigidBody2D
@export var enemy_bullet : PackedScene
@export var points = 100
var movement_direction = 0
var movement_speed = 0
var death_mark = false
var main
var timer := Timer.new()
var ready_to_fire = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$AnimatedSprite2D.animation = "default"
	main = $main
	add_child(timer)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	self.linear_velocity = Vector2(movement_direction, movement_speed)
	weapons_free()

func set_motion(direction, speed):
	movement_direction = direction
	movement_speed = speed

func enemy_death():
	$AnimatedSprite2D.animation = "death"
	$AnimatedSprite2D.play()
	$CollisionPolygon2D.set_deferred("disabled", true)
	increase_score()
	
func increase_score():
	if death_mark == false: # Prevent multiple bullets from counting score from the same enemy
		Game.score += points
		death_mark = true

func clear_enemies():
	get_tree().call_group("asteroids", "queue_free")
	
func weapons_free():
	print($VisibleOnScreenNotifier2D.visible)
	if ready_to_fire == true:
		$FirerateTimer.wait_time = randf_range(0.5, 1.2)
		fire_bullet()
		ready_to_fire = false
		#await get_tree().create_timer(1.0).timeout

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()

func _on_animated_sprite_2d_animation_finished() -> void:
	if $AnimatedSprite2D.animation == "death":
		$AnimatedSprite2D.hide()
		$AnimatedSprite2D.stop()

func fire_bullet() -> void:
	var b = enemy_bullet.instantiate()
	get_parent().add_child(b)
	b.transform = $Muzzle.global_transform


func _on_firerate_timer_timeout() -> void:
	if ready_to_fire == true:
		$FirerateTimer.wait_time = randf_range(0.8, 1.2)
		fire_bullet()
		ready_to_fire = false
	else: ready_to_fire = true
