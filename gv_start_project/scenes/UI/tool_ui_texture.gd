extends Control
var tool_enum: Enum.Tool
var seed_enum: Enum.Seed
@onready var texture_rect: TextureRect = $TextureRect

func setup_tool(new_tool_enum: Enum.Tool, main_texture: Texture2D):
	tool_enum = new_tool_enum
	texture_rect.texture = main_texture
	
func setup_seed(new_seed_enum: Enum.Seed, main_texture: Texture2D):
	seed_enum = new_seed_enum
	texture_rect.texture = main_texture

func highlight(selected: bool):
	var tween = create_tween()
	var target_size = Vector2(20,20) if selected else Vector2(16,16)
	tween.tween_property(texture_rect, "custom_minimum_size", target_size, 0.1)
