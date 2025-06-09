extends ParallaxBackground

@export var scrollSpeedY = 10;

func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	scroll_base_offset.y += scrollSpeedY * delta
