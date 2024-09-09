extends CharacterBody2D

@export var max_speed: float = 100.0
@export var acceleration: float = 100.0
@export var friction: float = 500.0
@export var direction_change_threshold: float = 0.4

var last_direction = Vector2.DOWN
var current_blend_position = Vector2.DOWN

@onready var animation_tree = $AnimationTree
@onready var state_machine = animation_tree.get("parameters/playback")
@onready var camera = $Camera2D


func _ready():
	animation_tree.active = true
	camera.make_current()


func _physics_process(delta):
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")

	if input_vector != Vector2.ZERO:
		input_vector = input_vector.normalized()

		var new_blend_position = determine_blend_position(input_vector)
		current_blend_position = current_blend_position.move_toward(
			new_blend_position, direction_change_threshold
		)

		animation_tree.set("parameters/Idle/blend_position", current_blend_position)
		animation_tree.set("parameters/Walk/blend_position", current_blend_position)

		state_machine.travel("Walk")

		velocity = velocity.move_toward(input_vector * max_speed, acceleration * delta)
	else:
		velocity = velocity.move_toward(Vector2.ZERO, friction * delta)
		if velocity.length() < 1:
			velocity = Vector2.ZERO
			state_machine.travel("Idle")

	move_and_slide()


func determine_blend_position(input_vector: Vector2) -> Vector2:
	var blend_position = Vector2.ZERO

	if abs(input_vector.x) > abs(input_vector.y):
		blend_position.x = sign(input_vector.x)
		blend_position.y = 0
	else:
		blend_position.x = 0
		blend_position.y = sign(input_vector.y)

	return blend_position


func _process(_delta):
	camera.align()
