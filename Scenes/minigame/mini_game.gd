class_name MiniGame
extends Node2D

const DROPPABLE_CARD_SCENE := preload("res://scenes/minigame/droppable_card.tscn")

@export var card_pile: PlayingCards


# Called when the node enters the scene tree for the first time.
func _ready():
	Events.playing_card_dropped.connect(queue_cards)
	queue_cards()


func queue_cards() -> void:
	# TODO add another to staging area? to see what's ahead
	add_card(get_random_card())


func add_card(card: PlayingCard) -> void:
	var new_droppable_card := DROPPABLE_CARD_SCENE.instantiate() as DroppableCard
	add_child(new_droppable_card)
	new_droppable_card.card = card
	# TODO positioning of card


func get_random_card() -> PlayingCard:
	return card_pile.cards.pick_random()
