extends Node2D

@onready var walls_layer: TileMapLayer = $WallsLayer
@onready var roof_layer: TileMapLayer = $RoofLayer
@onready var floor_layer: TileMapLayer = $FloorLayer
@onready var bed: StaticBody2D = $Bed
var door_cell_coord: Vector2i
signal reset_day

var in_house: bool:
	set(value):
		in_house = value
		walls_layer.set_cell(door_cell_coord, 0, Vector2i.ONE if value else Vector2i(0,4))
		var roof_tween = create_tween()
		if value:
			roof_tween.tween_property(roof_layer, "self_modulate", Color(1.0, 1.0, 1.0, 0.0), 0.2)
		else:
			roof_tween.tween_property(roof_layer, "self_modulate", Color(1.0, 1.0, 1.0, 1.0), 0.2)
		

func _ready() -> void:
	
	for cell in walls_layer.get_used_cells():
		floor_layer.set_cell(cell, 0, Vector2i.ZERO)
		if walls_layer.get_cell_atlas_coords(cell) == Vector2i(0,4):
			door_cell_coord = cell

func _on_house_area_body_entered(_body: Node2D) -> void:
	in_house = true


func _on_house_area_body_exited(_body: Node2D) -> void:
	in_house = false

func _on_bed_sleeping() -> void:
	reset_day.emit()
