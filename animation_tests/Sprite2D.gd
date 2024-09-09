#This is a way to test out new sprites on the world map
#Remember to press "F6" to run current scene and debug
extends CharacterBody2D

@export var max_speed: float = 200.0
@export var acceleration: float = 1000.0
@export var friction: float = 1500.0


func _physics_process(delta):
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	input_vector = input_vector.normalized()

	if input_vector != Vector2.ZERO:
		# Accelerate
		velocity = velocity.move_toward(input_vector * max_speed, acceleration * delta)
		$AnimationTree.set("parameters/Idle/blend_position", input_vector)
	else:
		# Decelerate
		velocity = velocity.move_toward(Vector2.ZERO, friction * delta)
		if velocity.length() < 1:
			velocity = Vector2.ZERO
		$AnimationTree.set("parameters/Idle/blend_position", velocity.normalized())

	move_and_slide()
