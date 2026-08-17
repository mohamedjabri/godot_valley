extends CharacterBody2D

const KNOCKBACK_SPEED = 220.0
const KNOCKBACK_FRICTION = 1000.0

@onready var flash_sprite_2d: Sprite2D = $FlashSprite2D
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var animation_player: AnimationPlayer = %AnimationPlayer
@onready var knockback_timer: Timer = $KnockbackTimer
signal exploded

var target_position: Vector2
var plant_target: StaticBody2D
var player: CharacterBody2D
var is_knocked_back: bool = false
var speed := 10.0
var has_exploded: bool = false
var health: int = 3:
	set(value):
		health = value
		if health <= 0: 
			animation_player.play("explode")
			await animation_player.animation_finished
			queue_free()
			
func set_direction():
	if plant_target:
		target_position = plant_target.global_position
	else:
		target_position = player.global_position
	var direction := global_position.direction_to(target_position)
	velocity = direction * speed

func _physics_process(delta: float) -> void:
	if is_knocked_back:
		velocity = velocity.move_toward(Vector2.ZERO, KNOCKBACK_FRICTION * delta)
	else:
		set_direction()
	move_and_slide()
	explode()

func hit(tool: Enum.Tool, dir: Vector2 = Vector2.ZERO) -> void:
	if tool == Enum.Tool.SWORD:
		flash_sprite_2d.flash()
		health -= 1
		var knockback_dir := dir if dir != Vector2.ZERO else global_position.direction_to(player.global_position)
		velocity = -1 * knockback_dir * KNOCKBACK_SPEED
		is_knocked_back = true
		knockback_timer.start(0.2)
		
func _on_knockback_timer_timeout() -> void:
	is_knocked_back = false
	
func explode():
	if has_exploded or global_position.distance_to(target_position) > 10:
		return
	has_exploded = true
	speed = 5
	animation_player.play("explode")
	await animation_player.animation_finished
	queue_free()
	exploded.emit()
