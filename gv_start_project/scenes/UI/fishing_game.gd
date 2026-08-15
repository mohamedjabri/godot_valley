extends Node2D

@onready var y_range = $Control/NinePatchRect.custom_minimum_size.y - 10
var velocity: float
var fish_velocity: float
var progress := 30.0
var sprite_size: Vector2
@onready var fish_sprite: Sprite2D = $FishSprite
@onready var fish_update_timer: Timer = $FishUpdateTimer
@onready var bar_sprite: Sprite2D = $BarSprite
@onready var texture_progress_bar: TextureProgressBar = $Control/TextureProgressBar

func _ready() -> void:
	hide()
	sprite_size = bar_sprite.get_rect().size

func _process(delta: float) -> void:
	if visible:
		# fish
		fish_sprite.position.y += fish_velocity * delta
		fish_sprite.position.y = clamp(fish_sprite.position.y, -y_range / 2.0, y_range / 2.0)
		
		var top_point = bar_sprite.position.y - sprite_size.y / 2
		var bottom_point = bar_sprite.position.y + sprite_size.y / 2
		
		if fish_sprite.position.y >= top_point and fish_sprite.position.y <= bottom_point:
			progress += 10 * delta
		else: 
			progress -= 20 * delta
		texture_progress_bar.value = progress
func reveal():
	show()
	fish_sprite.position.y = randf_range(-y_range / 2.0, y_range / 2.0)
	fish_velocity = randf_range(-20, 20)


func _on_fish_update_timer_timeout() -> void:
	fish_velocity = randf_range(-20, 20)
	fish_update_timer.wait_time = randf_range(1, 3)


func _on_texture_progress_bar_value_changed(value: float) -> void:
	if value <= 0 or value >= 100:
		hide()
		print("finished")
		get_parent().stop_fishing()
