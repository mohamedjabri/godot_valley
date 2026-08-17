extends Machine
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var timer: Timer = $Timer
@onready var texture_progress_bar: TextureProgressBar = $Control/TextureProgressBar

const  ANIMATIONS = {
	Vector2i.DOWN: 'down',
	Vector2i.LEFT: 'left',
	Vector2i.RIGHT: 'right',
	Vector2i.UP: 'up',
}
var direction := Vector2i.DOWN

func setup(pos: Vector2i, level: Node2D, parent: Node2D):
	var grass_layer = level.grass_layer as TileMapLayer
	var adjusted_coord = pos / Data.TILE_SIZE
	adjusted_coord.x += -1 if pos.x < 0 else 0
	adjusted_coord.y += -1 if pos.y < 0 else 0
	var tile_data = grass_layer.get_cell_tile_data(adjusted_coord) as TileData
	
	if tile_data.get_custom_data("coast"):
		direction = tile_data.get_custom_data("coast")
		print(direction)
		super.setup(pos, level, parent)

		

func _ready() -> void:
	start_fishing()

func _process(_delta: float) -> void:
	var progress = (1 - (timer.time_left / timer.wait_time)) * 100
	texture_progress_bar.value = progress


func _on_timer_timeout() -> void:
	start_fishing()

func start_fishing():
	animated_sprite_2d.play(ANIMATIONS[direction])
	await animated_sprite_2d.animation_finished
	animated_sprite_2d.play(ANIMATIONS[direction] + "_idle")
	timer.start()
