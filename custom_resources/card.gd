class_name Card
extends Resource

enum Type { ATTACK, DEFEND, SKILL }
# TODO rename SELF. it's actually all players and not self
enum Target { SELF, SINGLE_CHARACTER, SINGLE_ENEMY, ALL_ENEMIES, EVERYONE }

@export_group("Card Attributes")
@export var id: String
@export var type: Type
@export var target: Target
@export var cost: int

@export_group("Card Visuals")
@export var icon: Texture
@export_multiline var tooltip_text: String
@export var sound: AudioStream

var character_stats: CharacterStats


func set_character_stats(stats: CharacterStats):
	character_stats = stats


func get_character_stats() -> CharacterStats:
	return character_stats


func is_single_targeted() -> bool:
	return target == Target.SINGLE_ENEMY or target == Target.SINGLE_CHARACTER


func _get_targets(targets: Array[Node]) -> Array[Node]:
	if not targets:
		return []

	var tree = targets[0].get_tree()

	match target:
		Target.SELF:
			return tree.get_nodes_in_group("player")
		Target.ALL_ENEMIES:
			return tree.get_nodes_in_group("enemies")
		Target.EVERYONE:
			return tree.get_nodes_in_group("player") + tree.get_nodes_in_group("enemies")
		_:
			return []


func play(targets: Array[Node], char_stats: CharacterStats) -> bool:
	var valid_targets = _filter_targets_by_type(targets)
	if len(valid_targets) == 0:
		return false
	Events.card_played.emit(self)
	char_stats.mana -= cost

	if is_single_targeted():
		apply_effects(targets)
	else:
		apply_effects(_get_targets(targets))
	return true


# NOTE: this is pass because it's a virtual method. all cards will have this same method
# equivalent in python would be base class with class method and children
# can implement
func apply_effects(_targets: Array[Node]) -> void:
	pass


# Function to filter the targets based on the card's allowed target type
func is_valid_target(targted_item: Node) -> bool:
	match target:
		Target.SINGLE_CHARACTER:
			return targted_item is Player
		Target.SINGLE_ENEMY:
			return targted_item is Enemy

	return true


# Function to filter the targets based on the card's allowed target type
func _filter_targets_by_type(targets: Array[Node]) -> Array[Node]:
	var valid_targets: Array[Node] = []
	for targ in targets:
		if not target:
			continue
		# Filter based on target_type
		match target:
			Target.SINGLE_CHARACTER:
				if targ is Player:
					valid_targets.append(targ)
			Target.SINGLE_ENEMY:
				if targ is Enemy:
					valid_targets.append(targ)
			_:
				valid_targets.append(targ)

	return valid_targets
