extends Node2D
@onready var soil_layer: TileMapLayer = $Layers/SoilLayer
@onready var water_soil_layer: TileMapLayer = $Layers/WaterSoilLayer
@onready var grass_layer: TileMapLayer = $Layers/GrassLayer
@onready var player: CharacterBody2D = $Objects/Player
@export var daytime_color: Gradient
@export var daytime_color_rain: Color
@onready var day_timer: Timer = $Timers/DayTimer
@onready var day_time_color_canvas: CanvasModulate = $Overlay/DayTimeColorCanvas
@onready var day_transition_layer: ColorRect = %DayTransitionLayer
@onready var tree: StaticBody2D = $Objects/Tree
@onready var plant_info_container: Control = %PlantInfoContainer
@onready var rain_floot_particles: GPUParticles2D = $Layers/RainFlootParticles
@onready var rain_drops_particles: GPUParticles2D = $Overlay/RainDropsParticles

var plant_scene = preload("res://scenes/objects/plant.tscn")
var plant_info_scene = preload("res://scenes/UI/plant_info.tscn")
var used_cells: Array[Vector2i]
var raining: bool:
	set(value):
		raining = value
		rain_floot_particles.emitting = value
		rain_drops_particles.emitting = value
		
func _ready() -> void:
	Data.forecast_rain = [true, false].pick_random()
		
func _process(_delta: float) -> void:
	var daytime_point = 1 - (day_timer.time_left / day_timer.wait_time)
	var color = daytime_color.sample(daytime_point).lerp(daytime_color_rain, 0.5 if raining else 0.0)
	day_time_color_canvas.color = color
	if Input.is_action_just_pressed("day_change"):
		day_restart()

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
				var plant_res = PlantResource.new()
				plant_res.setup(player.current_seed)
				var plant = plant_scene.instantiate()
				plant.setup(grid_coord, $Objects, plant_res)
				used_cells.append(grid_coord)
				
				var plant_info = plant_info_scene.instantiate()
				plant_info_container.add(plant_info)
				plant_info.setup(plant_res) 
				plant.picked_dead.connect(func():
					used_cells.erase(grid_coord)
					plant_info_container.remove(plant_info)
				)

				
		Enum.Tool.AXE, Enum.Tool.SWORD:
			for object in get_tree().get_nodes_in_group("Objects"):
				if object.position.distance_to(pos) < 20:
					object.hit(tool)
				
func _on_player_diagnose() -> void:
	plant_info_container.visible = not plant_info_container.visible
	
func day_restart():
	var tween = create_tween()
	tween.tween_property(day_transition_layer.material, "shader_parameter/progress", 1.0, 1.0)
	tween.tween_interval(0.5)
	tween.tween_callback(level_reset)
	tween.tween_property(day_transition_layer.material, "shader_parameter/progress", 0.0, 1.0)
	
func level_reset():
	for plant in get_tree().get_nodes_in_group("Plants"):
		var watered: bool = plant.coord in water_soil_layer.get_used_cells()
		plant.manage(watered)
	for info in plant_info_container.get_infos():
		info.update_plant_info(info.res)
	water_soil_layer.clear()
	day_timer.start()
	if tree.health >= 0 and tree.health < tree.MAX_HEALTH:
		tree.reset()
	raining = Data.forecast_rain
	Data.forecast_rain = [true, false].pick_random()
		
	
