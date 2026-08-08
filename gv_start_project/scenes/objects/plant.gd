extends StaticBody2D
var coord: Vector2i
var death_counter: int = 0
var is_player_inside: bool = false
@export var res: PlantResource
@onready var sprite_2d: Sprite2D = $FlashSprite2D

func _process(_delta: float) -> void:
	pick_up()

func setup(grid_coord: Vector2i, parent: Node2D, plant_res: PlantResource):
	
	res = plant_res
	position = grid_coord * Data.TILE_SIZE  + Vector2i(8,5)
	parent.add_child(self)
	coord = grid_coord
	sprite_2d.texture = res.texture
	
func manage(watered: bool) -> void:
	if watered:
		res.grow(sprite_2d)
		death_counter = 0
	else:
		death_counter += 1
	if (death_counter == res.death_max) and (res.age < res.h_frames):
		res.die(self)
		
		
func pick_up() -> void:
	if is_player_inside and (Input.is_action_pressed("pick_up")) and (res.age >= res.h_frames):
		sprite_2d.flash(0.2, 0.4, queue_free)


func _on_pick_up_area_body_entered(body: Node2D) -> void:
	is_player_inside = true

func _on_pick_up_area_body_exited(body: Node2D) -> void:
	is_player_inside = false
