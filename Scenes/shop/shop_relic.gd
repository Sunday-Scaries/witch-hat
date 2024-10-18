class_name Shop
extends Control

@onready var cards: HBoxContainer = %Cards
@onready var card_tooltip_popup: CardTooltipPopup = %CardTooltipPopup


func _ready() -> void:
	for shop_card: ShopCard in cards.get_children():
		shop_card.current_card_ui.tooltip_requested.connect(card_tooltip_popup.show_tooltip)


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel") and card_tooltip_popup.visible:
		card_tooltip_popup.hide_tooltip()


func _on_button_pressed():
	Events.shop_exited.emit()
