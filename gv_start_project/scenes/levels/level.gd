extends Node2D
@onready var soil_layer: TileMapLayer = $Layers/SoilLayer
@onready var water_soil_layer: TileMapLayer = $Layers/WaterSoilLayer
@onready var grass_layer: TileMapLayer = $Layers/GrassLayer
@onready var player: CharacterBody2D = $Objects/Player

func _on_player_tool_use(tool: Enum.Tool, pos: Vector2) -> void:
	var grid_coord: Vector2i = soil_layer.local_to_map(soil_layer.to_local(pos))
	
	match tool:
		Enum.Tool.HOE:
			var cell = grass_layer.get_cell_tile_data(grid_coord) as TileData
			if cell and cell.get_custom_data("farmable"):
				soil_layer.set_cells_terrain_connect([grid_coord], 0, 0)
			
		Enum.Tool.WATER:
			var cell = soil_layer.get_cell_tile_data(grid_coord) as TileData
			if cell:
				water_soil_layer.set_cell(grid_coord, 0, Vector2i(randi_range(0,2), 0))
		
		Enum.Tool.FISH:
			if not grid_coord in grass_layer.get_used_cells():
				print("fishing")
				
				
			
