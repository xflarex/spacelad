extends RigidBody2D
@export var points = 100
var asteroidDirection
var asteroidSpeed
var rotation_speed
var markedForDeath = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var asteroids = Array($AnimatedSprite2D.sprite_frames.get_animation_names())
	$AnimatedSprite2D.animation = asteroids.pick_random()
	rotation_speed = 2 + randf()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	self.linear_velocity = Vector2(asteroidDirection, asteroidSpeed)
	$AnimatedSprite2D.rotation += rotation_speed * delta

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()

func set_asteroid_motion(x, y):
	asteroidDirection = x
	asteroidSpeed = y 

func asteroid_death():
	$AnimatedSprite2D.play()
	if markedForDeath == false:
		Game.score += points
		
		markedForDeath = true

func _on_animated_sprite_2d_animation_finished() -> void:
	$AnimatedSprite2D.stop()
	queue_free()

func clear_asteroids():
	get_tree().call_group("asteroids", "queue_free")
