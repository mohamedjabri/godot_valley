extends StaticBody2D
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var timer: Timer = $Timer

func interact(_player):
	animated_sprite_2d.play("Rain" if Data.forecast_rain else "Sun")
	timer.start()

func _on_timer_timeout() -> void:
	animated_sprite_2d.play("default")
