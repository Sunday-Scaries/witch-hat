class_name CharacterStats
extends Stats

@export_group("Visuals")
@export var character_name: String
@export_multiline var description: String
@export var portrait: Texture
@export var theme: StyleBoxFlat

@export_group("Gameplay Data")
@export var max_mana: int

var mana: int:
	set = set_mana
var deck: CardPile
var draftable_cards: CardPile


func set_mana(value: int) -> void:
	mana = value
	stats_changed.emit()


func reset_mana() -> void:
	mana = max_mana


func take_damage(damage: int) -> void:
	var initial_health := health
	super.take_damage(damage)
	if initial_health > health:
		Events.player_hit.emit()


func can_play_card(card: Card) -> bool:
	return mana >= card.cost && health > 0


func create_instance(starting_deck: CardPile, starting_draftable_cards: CardPile) -> Resource:
	var instance: CharacterStats = self.duplicate()
	instance.health = max_health
	instance.block = 0
	instance.reset_mana()
	if starting_deck:
		instance.deck = starting_deck.duplicate()
		# Assign CharacterStats to each card in the deck for theming
		for card in starting_deck.cards:
			card.set_character_stats(instance)

	if starting_draftable_cards:
		instance.draftable_cards = starting_draftable_cards.duplicate()
		# Assign CharacterStats to each card in the deck for theming
		for card in starting_draftable_cards.cards:
			card.set_character_stats(instance)
	return instance
