extends Control
const TOOL_TEXTURES = {
	Enum.Tool.AXE: preload("res://graphics/icons/axe.png"),
	Enum.Tool.HOE: preload("res://graphics/icons/hoe.png"),
	Enum.Tool.WATER: preload("res://graphics/icons/water.png"),
	Enum.Tool.SWORD: preload("res://graphics/icons/sword.png"),
	Enum.Tool.FISH: preload("res://graphics/icons/fish.png"),
	Enum.Tool.SEED: preload("res://graphics/icons/wheat.png")
}

const SEED_TEXTURES = {
	Enum.Seed.CORN: preload("res://graphics/icons/corn.png"),
	Enum.Seed.PUMPKIN: preload("res://graphics/icons/pumpkin.png"),
	Enum.Seed.TOMATO: preload("res://graphics/icons/tomato.png"),
	Enum.Seed.WHEAT: preload("res://graphics/icons/wheat.png")
}

@onready var seed_container: HBoxContainer = $SeedContainer
@onready var tool_container: HBoxContainer = $ToolContainer
@onready var tool_timer: Timer = $ToolTimer
var tool_texture_scene = preload("res://scenes/UI/tool_ui_texture.tscn")

func _ready() -> void:
	texture_setup(Enum.Tool.values(), TOOL_TEXTURES, tool_container)
	texture_setup(Enum.Seed.values(), SEED_TEXTURES, seed_container, true)
	tool_container.hide()
	seed_container.hide()

func texture_setup(enum_list: Array, textures: Dictionary, container: HBoxContainer, is_seed: bool = false):
	for enum_id in enum_list:
		var tool_texture = tool_texture_scene.instantiate()
		container.add_child(tool_texture)
		if is_seed:
			tool_texture.setup_seed(enum_id, textures[enum_id])
		else:
			tool_texture.setup_tool(enum_id, textures[enum_id])
		
func reveal_tool_container() -> void:
	seed_container.hide()
	tool_container.show()
	tool_timer.start()
	var target = get_parent().current_tool
	
	for texture in tool_container.get_children():

		texture.highlight(target == texture.tool_enum)
		
func reveal_seed_container() -> void:
	tool_container.hide()
	seed_container.show()
	tool_timer.start()
	var target = get_parent().current_seed
	
	for texture in seed_container.get_children():
		texture.highlight(target == texture.seed_enum)


func _on_tool_timer_timeout() -> void:
	tool_container.hide()
	seed_container.hide()
