extends Node2D

var draggable = false
var is_inside_droppable = false
var body_ref
var offset: Vector2
var initial_position: Vector2


func _process(_delta):
	if draggable:
		if Input.is_action_just_pressed("left_mouse"):
			initial_position = global_position
			offset = get_global_mouse_position() - global_position
			Dragging.is_dragging = true

		if Input.is_action_pressed("left_mouse"):
			global_position = get_global_mouse_position() - offset
		elif Input.is_action_just_released("left_mouse"):
			Dragging.is_dragging = false
			var tween = get_tree().create_tween()
			print("bodyref", body_ref.position)
			if is_inside_droppable:
				print("is inside droppable")
				tween.tween_property(self, "position", body_ref.position, 0.2).set_ease(
					Tween.EASE_OUT
				)
			else:
				tween.tween_property(self, "global_position", initial_position, 0.2).set_ease(
					Tween.EASE_OUT
				)


func _on_area_2d_mouse_entered():
	if not Dragging.is_dragging:
		draggable = true
		scale = Vector2(1.05, 1.05)


func _on_area_2d_mouse_exited():
	if not Dragging.is_dragging:
		draggable = false
		scale = Vector2(1, 1)


func _on_area_2d_body_entered(body: StaticBody2D):
	if body.is_in_group("droppable"):
		print("entered an area 2d")
		is_inside_droppable = true
		body.modulate = Color(Color.REBECCA_PURPLE, 1)
		body_ref = body


func _on_area_2d_body_exited(body: StaticBody2D):
	if body.is_in_group("droppable"):
		is_inside_droppable = false
		body.modulate = Color(Color.MEDIUM_PURPLE, 0.7)
