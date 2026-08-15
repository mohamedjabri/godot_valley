extends Machine
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var gpu_particles_2d: GPUParticles2D = $GPUParticles2D


func _on_timer_timeout() -> void:
	animated_sprite_2d.play("action")
	gpu_particles_2d.emitting = true
	await animated_sprite_2d.animation_finished
	animated_sprite_2d.play("default")
	
