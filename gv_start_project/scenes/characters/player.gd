extends CharacterBody2D
var direction: Vector2 
var last_direction: Vector2
var current_tool: Enum.Tool = Enum.Tool.SWORD
var current_seed: Enum.Seed = Enum.Seed.TOMATO
var can_move: bool = true
var current_state: Enum.State
var current_style: Enum.Style
@export var fish_bar_speed: float = 0.5

signal tool_use(tool: Enum.Tool, pos: Vector2)
signal diagnose

@export var speed: int = 50
@onready var animation_tree: AnimationTree = %AnimationTree
@onready var move_state_machine = animation_tree.get("parameters/MoveStateMachine/playback")
@onready var tool_state_machine = animation_tree.get("parameters/ToolStateMachine/playback")
@onready var tool_ui: Control = $ToolUI
@onready var ray_cast_2d: RayCast2D = $RayCast2D
@onready var fishing_game: Node2D = $FishingGame
@onready var sprite_2d: Sprite2D = $Sprite2D


func _physics_process(_delta: float) -> void:
	match current_state:
		Enum.State.DEFAULT:
			if can_move:
				move()
				animate()
				get_basic_input()
		Enum.State.FISHING:
			get_fishing_input()
	
	if direction:
		last_direction = direction
		var ray_y = int(direction.y) if not direction.x else 0
		ray_cast_2d.target_position = Vector2(direction.x,ray_y).normalized() * 20
		
	
func move() -> void:
	direction = Input.get_vector("left", "right", "up", "down")
	velocity = direction * speed
	move_and_slide()
	
func animate() -> void:
	if direction:
		move_state_machine.travel("Walk")
		var direction_animation = Vector2(round(direction.x), round(direction.y))
		animation_tree.set("parameters/MoveStateMachine/Idle/blend_position", direction_animation)
		animation_tree.set("parameters/MoveStateMachine/Walk/blend_position", direction_animation)
		animation_tree.set("parameters/FishIdleBlendSpace2D/blend_position", direction_animation)
		for action in Data.TOOL_STATE_ANIMATIONS.values():
			animation_tree.set("parameters/ToolStateMachine/" + action + "/blend_position", direction_animation)
	else:
		move_state_machine.travel("Idle")

func get_basic_input():
	
	if Input.is_action_just_pressed("tool_forward") or Input.is_action_just_pressed("tool_backward"):
		var dir = Input.get_axis("tool_backward", "tool_forward")
		current_tool = posmod(current_tool + int(dir), Enum.Tool.size()) as Enum.Tool
		tool_ui.reveal_tool_container()
	
	if Input.is_action_just_pressed("seed_forward"):
		current_seed = (current_seed + 1) % Enum.Seed.size() as Enum.Seed
		tool_ui.reveal_seed_container()
	
	if Input.is_action_just_pressed("action"):
		if not ray_cast_2d.get_collider():
			tool_state_machine.travel(Data.TOOL_STATE_ANIMATIONS[current_tool])
			animation_tree.set("parameters/ToolOneShot/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)
		else:
			ray_cast_2d.get_collider().interact(self)
		
	if Input.is_action_just_pressed("diagnose"):
		diagnose.emit()
		
	if Input.is_action_just_pressed("style_toggle"):
		current_style = posmod(current_style + 1, Enum.Style.size()) as Enum.Style
		print(Enum.Style.size())
		sprite_2d.texture = Data.PLAYER_SKINS[current_style]
	
func get_fishing_input():
	

	if Input.is_action_pressed("action"):
		fishing_game.bar_sprite.position.y -= fish_bar_speed
	else:
		fishing_game.bar_sprite.position.y += fish_bar_speed

	fishing_game.bar_sprite.position.y = clamp(
		fishing_game.bar_sprite.position.y,
		-fishing_game.y_range / 2.0 + (fishing_game.sprite_size.y/2 - 2), 
		fishing_game.y_range / 2.0 - (fishing_game.sprite_size.y/2 - 2)
	)

func start_fishing():
	$FishingGame.reveal()
	current_state = Enum.State.FISHING
	animation_tree.set("parameters/FishBlend/blend_amount", 1)
	
func stop_fishing():
	can_move = true
	current_state = Enum.State.DEFAULT
	animation_tree.set("parameters/FishBlend/blend_amount", 0)

func tool_use_emit():
	tool_use.emit(current_tool, position + last_direction * 16 + Vector2(0, 4))


func _on_animation_tree_animation_started(_anim_name: StringName) -> void:
	can_move = false


func _on_animation_tree_animation_finished(_anim_name: StringName) -> void:
	can_move = true
