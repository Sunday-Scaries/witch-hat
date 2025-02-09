class_name PlayingCard
extends Resource

enum Suit { HEARTS, DIAMONDS, CLUBS, SPADES }

@export_group("Card Attributes")
@export var name: String
@export var suit: Suit
@export var card_value: int

@export_group("Card Visuals")
@export var icon: Texture
