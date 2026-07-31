@tool
extends StaticBody2D
@onready var sprite_2d: Sprite2D = $Sprite2D
@export_range(0,3,1) var size: int
@export_enum('Bush', 'Rock') var style: int
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D

@export var random: bool

func _ready() -> void:
	if random:
		size = randi_range(0, sprite_2d.hframes -1)
		style = [0,1].pick_random()
	sprite_2d.frame_coords = Vector2i(size, style)
	collision_shape_2d.disabled = size < 2
	z_index = -1 if size < 2 else 0
