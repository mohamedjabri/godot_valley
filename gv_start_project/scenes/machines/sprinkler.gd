extends Machine
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var gpu_particles_2d: GPUParticles2D = $GPUParticles2D
signal water_plants(coord: Vector2i)

func setup(pos: Vector2i, level: Node2D, parent: Node2D):
	super.setup(pos, level, parent)
	connect('water_plants', level.water_plants)

func _on_timer_timeout() -> void:
	animated_sprite_2d.play("action")
	gpu_particles_2d.emitting = true
	await animated_sprite_2d.animation_finished
	animated_sprite_2d.play("default")
	water_plants.emit(coord)
