extends Area2D
@export var cannon_hit: PackedScene
var speed = 1800
var damage = 50

func _physics_process(delta: float) -> void:
	var bullet_speed = speed + (400 * Ship.cannons)
	position -= transform.y * bullet_speed * delta

func hit_particles():

	var explosion = cannon_hit.instantiate()
	get_parent().add_child(explosion)
	explosion.transform = global_transform

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("asteroids"):
		body.asteroid_death()
	
	if body.is_in_group("enemies"):
		hit_particles()
		body.enemy_damage(Ship.cannons * damage)
		queue_free()
	
	if body.is_in_group("boss"):
		hit_particles()
		body.enemy_damage(Ship.cannons * damage)
		queue_free()
