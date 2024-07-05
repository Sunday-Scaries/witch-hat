class_name CharacterStats
extends Stats

@export var starting_deck: CardPile
@export var max_mana: int

var mana: int: set = set_mana
var deck: CardPile

func set_mana(value: int) -> void:
	mana = value
	stats_changed.emit()
	
func reset_mana() -> void:
	self.mana = max_mana
	
func take_damage(damage: int) -> void:
	var initial_health := health
	super.take_damage(damage)
	if initial_health > health:
		Events.player_hit.emit()
	
func can_play_card(card: Card) -> bool:
	return mana >= card.cost
	
func create_instance() -> Resource:
	var instance: CharacterStats = self.duplicate()
	instance.health = max_health
	print(instance)
	instance.block = 0
	instance.reset_mana()
	instance.deck = instance.starting_deck.duplicate()
	return instance
