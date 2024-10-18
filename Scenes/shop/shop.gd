class_name ShopScene
extends Control

const SHOP_CARD = preload("res://Scenes/shop/shop_card.tscn")
# const SHOP_RELIC = preload("res://Scenes/shop/shop_relic.tscn")

# @export var shop_relics: Array[Relic]
@export var char_stats_list: Array[CharacterStats] = []
@export var run_stats: RunStats
# @export var relic_handler: RelicHandler

@onready var cards: HBoxContainer = %Cards
# @onready var relics: HBoxContainer = %Relics
@onready var shop_keeper_animation: AnimationPlayer = %ShopkeeperAnimation
@onready var blink_timer: Timer = %BlinkTimer
@onready var card_tooltip_popup: CardTooltipPopup = %CardTooltipPopup


func _ready() -> void:
	for shop_card: ShopCard in cards.get_children():
		shop_card.queue_free()

	# for shop_relic: ShopRelic in relics.get_children():
	# 	shop_relic.queue_free()

	Events.shop_card_bought.connect(_on_shop_card_bought)
	# Events.shop_relic_bought.connect(_on_shop_relic_bought)

	_blink_timer_setup()
	blink_timer.timeout.connect(_on_blink_timer_timeout)


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel") and card_tooltip_popup.visible:
		card_tooltip_popup.hide_tooltip()


func populate_shop() -> void:
	_generate_shop_cards()
	# _generate_shop_relics()


func _blink_timer_setup() -> void:
	blink_timer.wait_time = randf_range(1.0, 5.0)
	blink_timer.start()


func _generate_shop_cards() -> void:
	var shop_card_array: Array[Card] = []
	if char_stats_list.size() > 0:
		var available_cards := char_stats_list[0].draftable_cards.cards.duplicate(true)
		available_cards.shuffle()
		shop_card_array = available_cards.slice(0, 3)  # Select 3 random cards

	for card: Card in shop_card_array:
		var new_shop_card := SHOP_CARD.instantiate() as ShopCard
		cards.add_child(new_shop_card)
		new_shop_card.card = card
		new_shop_card.current_card_ui.tooltip_requested.connect(card_tooltip_popup.show_tooltip)
		new_shop_card.update(run_stats)


# func _generate_shop_relics() -> void:
# 	var shop_relics_array: Array[Relic] = []
# 	var available_relics := shop_relics.filter(
# 		func(relic: Relic):
# 			var can_appear := relic.can_appear_as_reward(char_stats)
# 			var already_had_it := relic_handler.has_relic(relic.id)
# 			return can_appear and not already_had_it
# 	)

# available_relics.shuffle()
# shop_relics_array = available_relics.slice(0, 3)

# for relic: Relic in shop_relics_array:
# 	var new_shop_relic := SHOP_RELIC.instantiate() as ShopRelic
# 	relics.add_child(new_shop_relic)
# 	new_shop_relic.relic = relic
# 	new_shop_relic.update(run_stats)


func _update_items() -> void:
	for shop_card: ShopCard in cards.get_children():
		shop_card.update(run_stats)

	# for shop_relic: ShopRelic in relics.get_children():
	# 	shop_relic.update(run_stats)


func _on_shop_card_bought(card: Card, gold_cost: int) -> void:
	char_stats_list[0].deck.add_card(card)
	run_stats.gold -= gold_cost
	_update_items()

	run_stats.gold -= gold_cost
	_update_items()


func _on_blink_timer_timeout() -> void:
	shop_keeper_animation.play("Blink")
	_blink_timer_setup()


func _on_back_button_pressed():
	Events.shop_exited.emit()

# func _on_shop_relic_bought(relic: Relic, gold_cost: int) -> void:
# 	relic_handler.add_relic(relic)
# 	run_stats.gold -= gold_cost
# 	_update_items()
