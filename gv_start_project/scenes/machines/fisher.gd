extends Machine
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var timer: Timer = $Timer
@onready var texture_progress_bar: TextureProgressBar = $Control/TextureProgressBar


func _ready() -> void:
	start_fishing()

func _process(_delta: float) -> void:
	var progress = (1 - (timer.time_left / timer.wait_time)) * 100
	texture_progress_bar.value = progress


func _on_timer_timeout() -> void:
	start_fishing()

func start_fishing():
	animated_sprite_2d.play("left")
	await animated_sprite_2d.animation_finished
	animated_sprite_2d.play("left_idle")
	timer.start()
