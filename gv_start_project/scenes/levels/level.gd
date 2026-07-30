extends Node2D
@onready var soil_layer: TileMapLayer = $Layers/SoilLayer
@onready var water_soil_layer: TileMapLayer = $Layers/WaterSoilLayer
@onready var grass_layer: TileMapLayer = $Layers/GrassLayer
@onready var player: CharacterBody2D = $Objects/Player

var plant_scene = preload("res://scenes/objects/plant.tscn")
var used_cells: Array[Vector2i]

func _on_player_tool_use(tool: Enum.Tool, pos: Vector2) -> void:
	var grid_coord: Vector2i = soil_layer.local_to_map(soil_layer.to_local(pos))
	var has_soil: bool = grid_coord in soil_layer.get_used_cells()
	
	match tool:
		Enum.Tool.HOE:
			var cell = grass_layer.get_cell_tile_data(grid_coord) as TileData
			if cell and cell.get_custom_data("farmable"):
				soil_layer.set_cells_terrain_connect([grid_coord], 0, 0)
			
		Enum.Tool.WATER:
			if has_soil:
				water_soil_layer.set_cell(grid_coord, 0, Vector2i(randi_range(0,2), 0))
		
		Enum.Tool.FISH:
			if not grid_coord in grass_layer.get_used_cells():
				print("fishing")
		
		Enum.Tool.SEED:
			if has_soil and grid_coord not in used_cells:
				var plant = plant_scene.instantiate()
				plant.setup(grid_coord, $Objects)
				used_cells.append(grid_coord)
				
				
			
