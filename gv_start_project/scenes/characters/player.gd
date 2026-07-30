extends CharacterBody2D
var direction: Vector2 
var last_direction: Vector2
var current_tool: Enum.Tool = Enum.Tool.SWORD
var current_seed: Enum.Seed = Enum.Seed.TOMATO
var can_move: bool = true

signal tool_use(tool: Enum.Tool, pos: Vector2)

@export var speed: int = 50
@onready var animation_tree: AnimationTree = %AnimationTree
@onready var move_state_machine = animation_tree.get("parameters/MoveStateMachine/playback")
@onready var tool_state_machine = animation_tree.get("parameters/ToolStateMachine/playback")


func _physics_process(_delta: float) -> void:
	if can_move:
		move()
		animate()
		get_basic_input()
	
	if direction:
		last_direction = direction
	
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
		for action in Data.TOOL_STATE_ANIMATIONS.values():
			animation_tree.set("parameters/ToolStateMachine/" + action + "/blend_position", direction_animation)
	else:
		move_state_machine.travel("Idle")
		

func get_basic_input():
	
	if Input.is_action_just_pressed("tool_forward") or Input.is_action_just_pressed("tool_backward"):
		var dir = Input.get_axis("tool_backward", "tool_forward")
		current_tool = posmod(current_tool + int(dir), Enum.Tool.size()) as Enum.Tool
	
	if Input.is_action_just_pressed("seed_forward"):
		current_seed = (current_seed + 1) % Enum.Seed.size() as Enum.Seed
		
	
	if Input.is_action_just_pressed("action"):
		tool_state_machine.travel(Data.TOOL_STATE_ANIMATIONS[current_tool])
		animation_tree.set("parameters/ToolOneShot/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)

		
func tool_use_emit():
	tool_use.emit(current_tool, position + last_direction * 16 + Vector2(0, 4))


func _on_animation_tree_animation_started(_anim_name: StringName) -> void:
	can_move = false


func _on_animation_tree_animation_finished(_anim_name: StringName) -> void:
	can_move = true
