extends Area2D
signal hit 

@export var Bullet : PackedScene
@export var speed = 500 # Default player speed

var screen_size
var target = Vector2.ZERO
var pause_status = true
var ready_to_fire = true


func _ready() -> void:
	screen_size = get_viewport_rect().size
	hide() # Hide player on start

func _process(delta: float) -> void:
	var velocity = Vector2.ZERO
	if pause_status == false:
		velocity = player_movement(velocity, delta) # Movement controls
		velocity = player_movement_animation(velocity) # Movement animations
		look_at(target)
		player_fire()  

func _input(event):
	target = get_viewport().get_mouse_position()

func _on_body_entered(body: Node2D) -> void:
	Ship.hull -= 1
	
	if Ship.hull <= 0:
		player_death()
		hit.emit()
	$Shield.show()
	$Shield.play()

func start(pos):
	position = pos
	show()
	$CollisionShape2D.disabled = false
	$Shield.hide()

func _on_timer_timeout() -> void:
	hide() # Hide player after death animation
	$AnimatedSprite2D.animation = "default"
	Ship.hull = 1

func player_movement(velocity, delta):
	if Ship.hull > 0: # If alive respond to movement commands
		if Input.is_action_pressed("move_left"):
			velocity.x -= 1
		if Input.is_action_pressed("move_right"):
			velocity.x += 1
		if Input.is_action_pressed("move_up"):
			velocity.y -= 1
		if Input.is_action_pressed("move_down"):
			velocity.y += 1
	
	if velocity.length() > 0:
		velocity = velocity.normalized() * (speed + (Ship.thrusters*100)) # Normalize the diagonals | Add thrusters
	
	position += velocity * delta # Clamp within bounds of screen
	position = position.clamp(Vector2.ZERO, screen_size)
	
	return velocity

func player_movement_animation(velocity):
	if Ship.hull > 0:
		if velocity.x == 0:
			$AnimatedSprite2D.animation = "default"
		elif velocity.x < 0: # and y is 0
			$AnimatedSprite2D.animation = "left"
		elif velocity.x > 0:
			$AnimatedSprite2D.animation = "right"
		
		$AnimatedSprite2D.play()

func player_fire():
	if Input.is_action_pressed("fire") && ready_to_fire == true:
		if Ship.cannons == 1:
			var b = Bullet.instantiate()
			owner.add_child(b)
			b.transform = $Muzzle.global_transform
		if Ship.cannons >= 2:
			var b = Bullet.instantiate()
			owner.add_child(b)
			b.transform = $Muzzle2.global_transform
			
			var c = Bullet.instantiate()
			owner.add_child(c)
			c.transform = $Muzzle3.global_transform
		if Ship.cannons >= 3:
			var b = Bullet.instantiate()
			owner.add_child(b)
			b.transform = $Muzzle4.global_transform
			
			var c = Bullet.instantiate()
			owner.add_child(c)
			c.transform = $Muzzle5.global_transform
		
		ready_to_fire = false

func player_death():
	$AnimatedSprite2D.animation = "death"
	$AnimatedSprite2D.play()
	$CollisionShape2D.set_deferred("disabled", true)
	$DeathTimer.start()
	get_tree().call_group("asteroids", "queue_free")
	pause_status = true

func _on_shield_animation_finished() -> void:
	$Shield.hide()

func _on_firerate_timeout() -> void:
	ready_to_fire = true
