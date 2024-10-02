class_name CardVisuals
extends Control

@export var card: Card:
	set = set_card

@onready var panel: Panel = $Panel
@onready var cost: Label = $Cost
@onready var icon: TextureRect = $Icon
@onready var rarity: TextureRect = $Rarity


func set_card(value: Card) -> void:
	if not is_node_ready():
		await ready

	card = value
	cost.text = str(card.cost)
	icon.texture = card.icon
	rarity.modulate = card.RARITY_COLORS[card.rarity]
#In some cases, enums and constants in a class cannot be accessed using the class name directly.
#Uses instance's reference (card), where RARITY_COLORS is defined, rather than through Card class.
