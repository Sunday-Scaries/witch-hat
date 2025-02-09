class_name Column
extends Node2D

enum ColumnValidity { VALID, INVALID, COMPLETE }

const VALUES = [2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14]
var valid_range = [2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14]

@onready var drop_area: StaticBody2D = %DropArea
@onready var cards: Array[DroppableCard] = []
@onready var initial_card: DroppableCard


# Call this method from the card when it’s dropped into the drop area.
func add_card(card: DroppableCard):
	# Convert card’s global position into the column's local space.
	var local_pos = to_local(card.global_position)
	# Reparent the card so it becomes a child of the column.
	card.get_parent().remove_child(card)
	add_child(card)
	card.position = local_pos

	# Assume the card has a method get_card_height() (see DroppableCard.gd below).
	var card_height = card.get_card_height()
	# Calculate the target position for the new card.
	# For example, assume drop_area.position is the bottom reference.
	var target_y = drop_area.position.y - (card_height - 5) * cards.size()
	var target_position = Vector2(drop_area.position.x, target_y)

	# Add the card to our list.
	cards.append(card)

	# Tween the card to its target position.
	print("tweening")
	var tween = get_tree().create_tween()
	tween.tween_property(card, "position", target_position, 0.3).set_ease(Tween.EASE_OUT)
	tween.tween_callback(on_card_dropped.bind(card))


# Called once the card has finished moving into place.
func on_card_dropped(card: DroppableCard) -> void:
	print("dropped")
	var column_validity = validate(card)
	if column_validity == ColumnValidity.COMPLETE:
		animate_column_complete()
	elif column_validity == ColumnValidity.INVALID:
		# TODO handle other invalid stuff
		clear_column()

	Events.playing_card_dropped.emit()


# update_valid_range will update valid_range with values we still consider to be valid
# after a card is dropped. This list is updated every card that is dropped
func update_valid_range(initial_val, dropped_val: int) -> void:
	var initial_index = valid_range.find(initial_val)
	var index = valid_range.find(dropped_val)
	if index < 0 or initial_index < 0:
		return

	if dropped_val > initial_val:
		# 0 to the initial value which for example could be 2, 3 and 4 if 4 is initial value
		var pre_possible_values = valid_range.slice(0, initial_index + 1)
		# dropped val to end of the list of possible values (ex. if dropped 5, new possible vals is 6-Ace)
		var exclusive_start = index + 1
		var end = len(valid_range) - 1
		var post_possible_values = valid_range.slice(exclusive_start, end)
		# add pre and post together, ruling out stuff in between
		valid_range = pre_possible_values + post_possible_values
	else:
		valid_range = valid_range.slice(index + 1, initial_index + 1)


# validate checks a column values against the newly dropped card to determine if
# the column is valid, invalid or complete
func validate(dropped_card: DroppableCard) -> ColumnValidity:
	# You need at least two cards (start and finish)
	if cards.size() < 2:
		return ColumnValidity.VALID

	var initial_val = cards[0].card.card_value
	var dropped_val = dropped_card.card.card_value

	if dropped_val == initial_val:
		print("Column complete!")
		return ColumnValidity.COMPLETE

	print("pre check ", valid_range)
	if !valid_range.has(dropped_val):
		print("Column not valid, not in possible_vals")
		return ColumnValidity.INVALID

	update_valid_range(initial_val, dropped_val)

	print("post update ", valid_range)
	return ColumnValidity.VALID


func clear_column() -> void:
	valid_range = VALUES
	for card in cards:
		card.queue_free()
	cards.clear()


# Animate the column’s complete effect.
func animate_column_complete() -> void:
	# TODO
	# this animation should clear the column when done
	print("ANIMATING!!!!")
	# but for now will manually clear it
	clear_column()
	# Play an animation (you need to create this in an AnimationPlayer node)
	var anim_player = get_node("AnimationPlayer")
	if anim_player:
		anim_player.play("complete")
	# Optionally trigger a particle effect:
	var particles = get_node("Particles2D")
	if particles:
		particles.emitting = true
