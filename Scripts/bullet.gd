extends Area2D
var speed = 1800


func _physics_process(delta: float) -> void:
	var bullet_speed = speed + (400 * Ship.cannons)
	position -= transform.y * bullet_speed * delta

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("asteroids"):
		body.asteroid_death()
	#queue_free()
	if body.is_in_group("enemies"):
		body.enemy_death()
	
