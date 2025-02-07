class_name Column
extends Node2D

@onready var drop_area: StaticBody2D = %DropArea

@onready var cards = []


# Call this method from the card when it’s dropped into the drop area.
func add_card(card):
	# Convert card’s global position into the column's local space.
	var local_pos = to_local(card.global_position)
	# Reparent the card so it becomes a child of the column.
	card.get_parent().remove_child(card)
	add_child(card)
	card.position = local_pos
	print("card", card)

	# Assume the card has a method get_card_height() (see DroppableCard.gd below).
	var card_height = card.get_card_height()
	# Calculate the target position for the new card.
	# For example, assume drop_area.position is the bottom reference.
	var target_y = drop_area.position.y - (card_height - 5) * cards.size()
	var target_position = Vector2(drop_area.position.x, target_y)
	print("Target y ", target_y)
	print("Target position ", target_position)

	# Add the card to our list.
	cards.append(card)

	# Tween the card to its target position.
	var tween = get_tree().create_tween()
	tween.tween_property(card, "position", target_position, 0.3).set_ease(Tween.EASE_OUT)
	tween.tween_callback(on_card_dropped)


# Called once the card has finished moving into place.
# TODO card arg
func on_card_dropped(_card):
	# Check if this column now satisfies the “completed” condition.
	print("on card dropped")
	if is_column_complete():
		animate_column_complete()


# Define your matching logic for a completed column.
func is_column_complete() -> bool:
	# Example: you might check if the first and last cards have matching values.
	# Return true if complete, false otherwise.
	return false


# Animate the column’s complete effect.
func animate_column_complete():
	# Play an animation (you need to create this in an AnimationPlayer node)
	var anim_player = get_node("AnimationPlayer")
	if anim_player:
		anim_player.play("complete")
	# Optionally trigger a particle effect:
	var particles = get_node("Particles2D")
	if particles:
		particles.emitting = true
