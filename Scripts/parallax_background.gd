extends ParallaxBackground
@export var scrollSpeedY = 100

func _physics_process(delta: float) -> void:
	scroll_base_offset.y += scrollSpeedY * delta
