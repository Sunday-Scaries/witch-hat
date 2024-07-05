class_name PlayerHandler
extends Node

const HAND_DRAW_INTERVAL := 0.25
const HAND_DISCARD_INTERVAL := 0.25

@export var hand: Hand
@export var cards_per_turn: int

var draw_pile: CardPile
var discard: CardPile

var characters: Array[CharacterStats] = []

func _ready() -> void:
	Events.card_played.connect(_on_card_played)
	draw_pile = CardPile.new()
	discard = CardPile.new()

func start_battle(char_stats_arr: Array[CharacterStats]) -> void:
	var draw_pile_arr: Array[CardPile] = []
	print('char stats', char_stats_arr)
	for i in char_stats_arr.size():
		# assign passed in character stats
		characters.append(char_stats_arr[i])
		# add to the global draw pile
		var char_draw_deck: CardPile = characters[i].deck.duplicate(true)
		draw_pile_arr.append(char_draw_deck)
		discard = CardPile.new()
	
	for deck in draw_pile_arr:
		for card in deck.cards:
			draw_pile.cards.append(card)
	draw_pile.shuffle()
	start_turn()

func start_turn() -> void:
	for i in characters.size():
		characters[i].block = 0
		characters[i].reset_mana()
	
	draw_cards(cards_per_turn)

func end_turn() -> void:
	hand.disable_hand()
	discard_cards()

func draw_card() -> void:
	reshuffle_deck_from_discard()
	hand.add_card(draw_pile.draw_card())
	reshuffle_deck_from_discard()

func draw_cards(amount: int) -> void:
	var tween := create_tween()
	for i in range(amount):
		tween.tween_callback(draw_card)
		tween.tween_interval(HAND_DRAW_INTERVAL)
	
	tween.finished.connect(
		func(): Events.player_hand_drawn.emit()
	)

func discard_cards() -> void:
	var tween := create_tween()
	for card_ui: CardUI in hand.get_children():
		tween.tween_callback(discard.add_card.bind(card_ui.card))
		tween.tween_callback(hand.discard_card.bind(card_ui))
		tween.tween_interval(HAND_DISCARD_INTERVAL)
	
	tween.finished.connect(
		func():
			Events.player_hand_discarded.emit()
	)

func reshuffle_deck_from_discard() -> void:
	if not draw_pile.empty():
		return

	while not discard.empty():
		draw_pile.add_card(discard.draw_card())

	draw_pile.shuffle()

func _on_card_played(card: Card) -> void:
	discard.add_card(card)
