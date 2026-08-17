class_name PlantResource extends Resource

@export var texture: Texture2D
@export var grow_speed: float = 1.0
@export var h_frames: int = 3
@export var death_max: int = 3
@export var icon: Texture2D
@export var name: String

var age: float
var death_counter: int = 0
var damage_counter: float = 0.0

func grow(plant_sprite: Sprite2D):
	age = min(age + grow_speed, h_frames)
	plant_sprite.frame = int(age)

func die(plant: StaticBody2D):
	plant.queue_free()
	
func setup(seed_enum: Enum.Seed):
	texture = load(Data.PLANT_DATA[seed_enum]["texture"])
	icon = load(Data.PLANT_DATA[seed_enum]["icon_texture"])
	name = Data.PLANT_DATA[seed_enum]["name"]
	grow_speed = Data.PLANT_DATA[seed_enum]["grow_speed"]
	h_frames = Data.PLANT_DATA[seed_enum]["h_frames"]
	death_max = Data.PLANT_DATA[seed_enum]["death_max"]
	
	
