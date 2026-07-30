extends StaticBody2D
const APPLE_TEXTURE = preload("res://graphics/plants/apple.png")
@onready var flash_sprite_2d: Sprite2D = $FlashSprite2D
@onready var apple_spawn_position: Node2D = $AppleSpawnPosition
@onready var apples: Node2D = $Apples
@onready var stump: Sprite2D = $Stump
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D

var health : int = 3:
	set(value):
		health = value
		if health <= 0:
			flash_sprite_2d.hide()
			stump.show()
			var shape = RectangleShape2D.new()
			shape.size = Vector2(12,6)
			collision_shape_2d.shape = shape
			collision_shape_2d.position.y = 8


# tree should flash when hit
# apples should disappear when hit
# tree is killable


func _ready():
	create_apples(3)


func hit(tool: Enum.Tool) -> void:
	if tool == Enum.Tool.AXE:
		flash_sprite_2d.flash()
		get_apple()
		health -= 1


func create_apples(num: int):
	var apple_markers = apple_spawn_position.get_children().duplicate(true)
	for i in num:
		var pos_marker = apple_markers.pop_at(randi_range(0, apple_markers.size() - 1 ))
		var sprite = Sprite2D.new()
		sprite.texture = APPLE_TEXTURE
		apples.add_child(sprite)
		sprite.position = pos_marker.position
		
		
func  get_apple():
	if apples.get_children():
		apples.get_children().pick_random().queue_free()
	
