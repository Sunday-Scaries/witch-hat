class_name PlayingCards
extends Resource

@export var cards: Array[PlayingCard] = []


func empty() -> bool:
	return cards.is_empty()


func draw_card() -> Card:
	var card = cards.pop_front()
	return card


func add_card(card: Card) -> void:
	cards.append(card)


func shuffle() -> void:
	cards.shuffle()


func clear() -> void:
	cards.clear()


func _to_string() -> String:
	var card_strings: PackedStringArray = []
	for i in range(cards.size()):
		card_strings.append("%s: %s" % [i + 1, cards[i].id])
	return "\n".join(card_strings)
