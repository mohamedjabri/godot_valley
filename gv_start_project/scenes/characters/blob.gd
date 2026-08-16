extends CharacterBody2D

const SPEED = 10.0
const KNOCKBACK_SPEED = 220.0
const KNOCKBACK_FRICTION = 1000.0

@onready var flash_sprite_2d: Sprite2D = $FlashSprite2D
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var animation_player: AnimationPlayer = %AnimationPlayer
@onready var player: CharacterBody2D = %Player
@onready var knockback_timer: Timer = $KnockbackTimer

var is_knocked_back: bool = false
var health: int = 2:
	set(value):
		health = value
		if health <= 0: 
			animation_player.play("explode")
			await animation_player.animation_finished
			queue_free()

func _physics_process(delta: float) -> void:
	if is_knocked_back:
		velocity = velocity.move_toward(Vector2.ZERO, KNOCKBACK_FRICTION * delta)
	else:
		var direction := global_position.direction_to(player.global_position)
		velocity = direction * SPEED
	move_and_slide()

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
