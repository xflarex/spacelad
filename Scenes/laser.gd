@tool
extends RayCast2D

@export var cast_speed := 1700.0
@export var max_length := 1400.0

@export var is_casting := false: set = set_is_casting
@export var color := Color.PURPLE: set = set_color

func _physics_process(delta: float) -> void:
	target_position.move_toward(
		target_position,
		cast_speed
	)

func set_is_casting(new_value: bool) -> void:
	if is_casting == new_value:
		return
	is_casting = new_value
	
	set_is_casting(is_casting)
	
	if is_casting == false:
		target_position = Vector2(0.0,0.0)

func set_color(new_color: Color) -> void:
	color = new_color
