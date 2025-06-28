extends RigidBody2D

@export var health = 2000
var points = 2000
var death_mark = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if position.y <= 100:
		linear_velocity = Vector2(0, 100)
	else:
		position = Vector2( (Game.screen_size.x/2), 100 )

func enemy_damage(damage):
	health -= damage
	print(health)
	if health <= 0:
		enemy_death()

func enemy_death():
	#$AnimatedSprite2D.animation = "death"
	#$AnimatedSprite2D.play()
	$CollisionShape2D.set_deferred("disabled", true)
	queue_free()
	increase_score()
	
func increase_score():
	if death_mark == false: # Prevent multiple bullets from counting score from the same enemy
		Game.score += points
		death_mark = true
