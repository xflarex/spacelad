extends RigidBody2D
@export var enemy_bullet : PackedScene
@export var points = 100
var movement_direction = 0
var movement_speed = 0
var death_mark = false
var main
var timer := Timer.new()
var ready_to_fire = true

var tracking = false
var first_rotation = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$AnimatedSprite2D.animation = "default"
	main = $main
	add_child(timer)
	if randi_range(0,7) <= 1:
		tracking = true
		$AnimatedSprite2D.animation = "aggro"

func _physics_process(delta: float) -> void:
	self.linear_velocity = Vector2(movement_direction, movement_speed)
	rotate_towards_player()
	weapons_free()
	

func set_motion(direction, speed):
	movement_direction = direction
	movement_speed = speed
	movement_speed = 200

func enemy_death():
	$AnimatedSprite2D.animation = "death"
	$AnimatedSprite2D.play()
	$CollisionShape2D.set_deferred("disabled", true)
	queue_free()
	increase_score()
	
func increase_score():
	if death_mark == false: # Prevent multiple bullets from counting score from the same enemy
		Game.score += points
		death_mark = true

func clear_enemies():
	get_tree().call_group("enemies", "queue_free")
	
func weapons_free():
	if ready_to_fire == true && death_mark == false:
		$FirerateTimer.wait_time = randf_range(0.5, 1.2)
		#rotate_towards_player()
		fire_bullet()
		ready_to_fire = false

func rotate_towards_player():
		if tracking == true && first_rotation == true:
			
			look_at(Ship.player_node.global_position)
			rotation -= PI / 2

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	ready_to_fire = false
	death_mark = false
	queue_free()

func _on_animated_sprite_2d_animation_finished() -> void:
	if $AnimatedSprite2D.animation == "death":
		$AnimatedSprite2D.hide()
		$AnimatedSprite2D.stop()

func fire_bullet() -> void:
	if ready_to_fire == true && death_mark == false:
		var b = enemy_bullet.instantiate()
		get_parent().add_child(b)
		b.transform = $Muzzle.global_transform


func _on_firerate_timer_timeout() -> void:
	if ready_to_fire == true:
		$FirerateTimer.wait_time = randf_range(2.0, 5.0)
		fire_bullet()
		ready_to_fire = false
	else:
		ready_to_fire = true
		first_rotation = true


func _on_body_shape_entered(body_rid: RID, body: Node, body_shape_index: int, local_shape_index: int) -> void:
	print("entered ", body)
	if body.is_in_group("player"):
		print("entered ", body)
		body.been_shot()
