extends Control
var tool_enum: Enum.Tool
@onready var texture_rect: TextureRect = $TextureRect

func setup(new_tool_enum: Enum.Tool, main_texture: Texture2D):
	tool_enum = new_tool_enum
	texture_rect.texture = main_texture
