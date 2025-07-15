extends RigidBody2D

@export var basic_attack: PackedScene
@export var health = 5000
var points = 2000
var death_mark = false
var stat_menu
var ready_to_attack = false
var attacking := false

func _physics_process(delta: float) -> void:
	if position.y <= 300:
		linear_velocity = Vector2(0, 100)
	else:
		linear_velocity = Vector2.ZERO
		#position = Vector2( (Game.screen_size.x/2), 300 )
		if ready_to_attack == false:
			$BasicAttackTimer.start()
			ready_to_attack = true
	basic_attack_rotate_towards()
	fire_on_correct_frame()
	

func enemy_damage(damage):
	health -= damage
	if health <= 0:
		enemy_death()

func enemy_death():
	#$AnimatedSprite2D.animation = "death"
	#$AnimatedSprite2D.play()
	$CollisionShape2D.set_deferred("disabled", true)
	queue_free()
	increase_score()
	Game.gamestate = Game.state.STAT_MENU
	
func increase_score():
	if death_mark == false: # Prevent multiple bullets from counting score from the same enemy
		Game.score += points
		death_mark = true

func basic_attack_fire():
	var b = basic_attack.instantiate()
	get_parent().add_child(b)
	b.transform = $Area2D/Marker2D.global_transform

func _on_basic_attack_timer_timeout() -> void:
	$AnimatedSprite2D.play("BasicAttack")
	attacking = true

func fire_on_correct_frame():
	if attacking == true:
		if $AnimatedSprite2D.get_frame() == 6:
			attacking = false
			basic_attack_fire()

func basic_attack_rotate_towards():
	$Area2D.look_at(Ship.player_node.global_position)
	$Area2D.rotation -= PI / 2
