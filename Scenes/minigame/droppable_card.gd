class_name DroppableCard
extends Node2D

@export var card: PlayingCard:
	set = _set_card

var has_been_dropped = false
var draggable = false
var is_inside_droppable = false
var body_ref
var offset: Vector2
var initial_position: Vector2

@onready var card_sprite = $Card


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
			if is_inside_droppable:
				has_been_dropped = true
				draggable = false
				scale = Vector2(1, 1)

				# Instead of tweening directly to the drop area,
				# delegate the card placement to the column.
				var column = body_ref.get_parent()  # Assuming the drop area is a child of Column.
				if column and column.has_method("add_card"):
					column.add_card(self)
			else:
				tween.tween_property(self, "global_position", initial_position, 0.2).set_ease(
					Tween.EASE_OUT
				)


func _set_card(value: PlayingCard) -> void:
	if not is_node_ready():
		await ready

	card = value
	card_sprite.texture = card.icon


func _on_area_2d_mouse_entered():
	if not Dragging.is_dragging and not has_been_dropped:
		draggable = true
		scale = Vector2(1.05, 1.05)


func _on_area_2d_mouse_exited():
	if not Dragging.is_dragging and not has_been_dropped:
		draggable = false
		scale = Vector2(1, 1)


func _on_area_2d_body_entered(body: StaticBody2D):
	if body.is_in_group("droppable"):
		is_inside_droppable = true
		body.modulate = Color(Color.REBECCA_PURPLE, 1)
		body_ref = body


func _on_area_2d_body_exited(body: StaticBody2D):
	if body.is_in_group("droppable"):
		is_inside_droppable = false
		body.modulate = Color(Color.MEDIUM_PURPLE, 0.7)


# Helper function to return the card's height.
func get_card_height() -> float:
	# Assuming there is a Sprite node as a child.
	return $Card.texture.get_size().y * scale.y
