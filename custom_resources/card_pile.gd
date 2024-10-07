class_name CardPile
extends Resource

signal card_pile_size_changed(cards_amount)

# NOTE: this can't be Array[Card] because of weird godot errors when adding in editor. may
# be fixed in later versions
@export var cards: Array[Card] = []


func empty() -> bool:
	return cards.is_empty()


func draw_card() -> Card:
	var card = cards.pop_front()
	card_pile_size_changed.emit(cards.size())
	return card


func add_card(card: Card) -> void:
	cards.append(card)
	card_pile_size_changed.emit(cards.size())


func shuffle() -> void:
	cards.shuffle()


func clear() -> void:
	cards.clear()
	card_pile_size_changed.emit(cards.size())


func _to_string() -> String:
	var card_strings: PackedStringArray = []
	for i in range(cards.size()):
		card_strings.append("%s: %s" % [i + 1, cards[i].id])
	return "\n".join(card_strings)
