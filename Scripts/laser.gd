@tool
extends RayCast2D

@export var speed := 10000.0
@export var max_length := 2000.0

@export var is_casting := false: set = set_is_casting
@export var color := Color.WHITE: set = set_color

var tween: Tween = null
@onready var beam: Line2D = $Beam
@onready var beam_length: float = $Beam.width
@export var laser_speed := 0.1

func _ready() -> void:
	beam.visible = false
	set_color(color)
	set_is_casting(is_casting)
	
	if not Engine.is_editor_hint():
		set_physics_process(false)

func _physics_process(delta: float) -> void:
	#set_direction()
	pass
	#target_position.x = move_toward(target_position.x, max_length, speed * delta)

func rotate_clockwise(rot: float):
	rotation += rot

func rotate_counter_clockwise(rot: float):
	rotation -= rot

func set_direction(target: Vector2):
	if target.x > global_position.x:
		rotate_counter_clockwise(0.01)
	else:
		rotate_clockwise(0.01)

func set_color(new_color: Color):
	color = new_color

	if beam == null:
		return
	
	beam.modulate = new_color

func set_is_casting(new_value: bool) -> void:
	if is_casting == new_value:
		return
	is_casting = new_value
	set_physics_process(is_casting)
	
	if is_casting == false:
		target_position.x = 0.0
		disappear()
	else:
		appear()
		
func appear():
	beam.visible = true
	if tween and tween.is_running():
		tween.kill()
	tween = create_tween()
	tween.tween_property(beam, "width", beam_length, laser_speed * 2.0).from(0.0)


func disappear():
	#beam.visible = false
	if tween and tween.is_running():
		tween.kill()
	tween = create_tween()
	tween.tween_property(beam, "width", 0.0, laser_speed).from_current()
	tween.tween_callback(beam.hide)
