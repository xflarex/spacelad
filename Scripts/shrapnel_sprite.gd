extends Sprite2D
var speed = Vector2.ZERO
@export var min_wait = 0
@export var max_wait = 100
@onready var timer = $Timer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Game.screen_size = get_viewport().size # Fill screen_size if unfilled
	timer.set_wait_time(randf_range(min_wait,max_wait))
	print(timer.get_wait_time())
	timer.start()
	start_position()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	self.position += speed * delta
	

func reset():
	stop_moving()
	start_position()
	timer.set_wait_time(randf_range(min_wait,max_wait))
	timer.start()

func start_moving():
	speed = Vector2(0, 100)

func stop_moving():
	speed = Vector2.ZERO

func start_position():
	self.global_position = Vector2(randi_range(-10, Game.screen_size.x+10), -100)

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	reset()

func _on_timer_timeout() -> void:
	start_moving()
