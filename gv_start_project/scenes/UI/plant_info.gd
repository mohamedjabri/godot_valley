extends PanelContainer

@onready var icon_texture: TextureRect = $HBoxContainer/IconTexture
@onready var name_label: Label = $HBoxContainer/VBoxContainer/NameLabel
@onready var growth_bar: TextureProgressBar = $HBoxContainer/VBoxContainer/GrowthBar
@onready var death_bar: TextureProgressBar = $HBoxContainer/VBoxContainer/DeathBar
@onready var damage_bar: TextureProgressBar = $HBoxContainer/VBoxContainer/DamageBar
var growth_pct: float = 0.0
var death_pct: float = 0.0
var damage_pct: float = 0.0
@export var res: PlantResource

func setup(plant_res: PlantResource):
	res = plant_res
	name_label.text = plant_res.name
	icon_texture.texture = plant_res.icon
	
func update_plant_info(plant_res: PlantResource):
	res = plant_res
	growth_pct = min( (res.age / res.h_frames) * 100, 100)
	death_pct = min((float(res.death_counter) / res.death_max) * 100, 100)
	damage_pct = min((float(res.damage_counter) / res.death_max) * 100, 100)
	growth_bar.value = growth_pct
	death_bar.value = death_pct
	damage_bar.value = damage_pct
