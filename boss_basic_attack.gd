extends Area2D
@export var cannon_hit: PackedScene
@export var speed = 350
@export var damage = 50


func _physics_process(delta: float) -> void:
	position += transform.y * speed * delta
	rotate_towards(delta)
	#print("rotation: ", rotation, "  global_rotation: ", global_rotation, "  rotation_degrees: ", rotation_degrees)
	#set_scale(Vector2(0.5,0.5))
	grow()

func grow():
	if get_scale() < Vector2(2.0, 2.0):
		set_scale(get_scale() + Vector2(0.01,0.01))

func hit_particles():
	var explosion = cannon_hit.instantiate()
	get_parent().add_child(explosion)
	explosion.transform = global_transform

func rotate_towards(delta):
	
	var target_angle = global_position.angle_to_point(Ship.player_node.global_position) - PI/2.0
	rotation = rotate_toward(rotation, target_angle, 0.5 * delta)

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		hit_particles()
		body.been_shot()

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()

func _on_visible_on_screen_notifier_2d_screen_entered() -> void:
	set_scale(Vector2(0.5,0.5))
