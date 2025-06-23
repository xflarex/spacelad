extends CharacterBody2D

var target = Vector2.ZERO

func _physics_process(delta: float) -> void:
	look_at(target)
	

func _input(event: InputEvent) -> void:
	target = get_viewport().get_mouse_position()
