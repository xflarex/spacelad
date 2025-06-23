extends Area2D
var speed = 800


func _physics_process(delta: float) -> void:
	position += transform.y * speed * delta

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		body.been_shot()
