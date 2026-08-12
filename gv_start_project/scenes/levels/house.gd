extends Node2D

@onready var walls_layer: TileMapLayer = $WallsLayer
var door_cell_coord: Vector2i

var in_house: bool:
	set(value):
		in_house = value
		walls_layer.set_cell(door_cell_coord, 0, Vector2i.ONE if value else Vector2i(0,4))
		

func _ready() -> void:
	for cell in walls_layer.get_used_cells():
		if walls_layer.get_cell_atlas_coords(cell) == Vector2i(0,4):
			door_cell_coord = cell

func _on_house_area_body_entered(_body: Node2D) -> void:
	in_house = true


func _on_house_area_body_exited(_body: Node2D) -> void:
	in_house = false
