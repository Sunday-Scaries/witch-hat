class_name BattleReward
extends Control

const CARD_REWARDS = preload("res://scenes/ui/card_rewards.tscn")
const REWARD_BUTTON = preload("res://scenes/ui/reward_button.tscn")
const GOLD_ICON = preload("res://art/gold.png")
const GOLD_TEXT := "%s gold"
const CARD_ICON := preload("res://art/rarity.png")
const CARD_TEXT := "Add New Card"

@export var run_stats: RunStats
# TODO I think we can do this in a shared resource maybe?
# This is getting duplicated in a lot of places
@export var character_stats_list: Array[CharacterStats]

var card_reward_total_weight := 0.0
var card_rarity_weights := {
	Card.Rarity.COMMON: 0.0,
	Card.Rarity.UNCOMMON: 0.0,
	Card.Rarity.RARE: 0.0,
}
@onready var rewards: VBoxContainer = %Rewards


func _ready() -> void:
	for node: Node in rewards.get_children():
		node.queue_free()


func add_gold_reward(amount: int) -> void:
	var gold_reward := REWARD_BUTTON.instantiate() as RewardButton
	gold_reward.reward_icon = GOLD_ICON
	gold_reward.reward_text = GOLD_TEXT % amount
	gold_reward.pressed.connect(_on_gold_reward_taken.bind(amount))
	# deferred call becuase we want this to happen at end of frame
	rewards.add_child.call_deferred(gold_reward)


func _on_gold_reward_taken(amount: int) -> void:
	if not run_stats:
		return

	run_stats.gold += amount


func _on_back_button_pressed() -> void:
	Events.battle_reward_exited.emit()


func add_card_reward() -> void:
	var card_reward := REWARD_BUTTON.instantiate() as RewardButton
	card_reward.reward_icon = CARD_ICON
	card_reward.reward_text = CARD_TEXT
	card_reward.pressed.connect(_show_card_rewards)
	rewards.add_child.call_deferred(card_reward)


func _show_card_rewards() -> void:
	if not run_stats or not character_stats_list:
		return

	var card_rewards := CARD_REWARDS.instantiate() as CardRewards
	add_child(card_rewards)
	card_rewards.card_reward_selected.connect(_on_card_reward_taken)

	var card_reward_array: Array[Card] = []
	var available_cards: Array[Card] = []
	for character in character_stats_list:
		var draftable_cards := character.draftable_cards.cards.duplicate(true)
		for card in draftable_cards:
			available_cards.append(card)

	for i in run_stats.card_rewards:
		_setup_card_chances()
		var roll := randf_range(0.0, card_reward_total_weight)

		for rarity: Card.Rarity in card_rarity_weights:
			if card_rarity_weights[rarity] > roll:
				_modify_weights(rarity)

				var picked_card := _get_random_available_card(available_cards, rarity)
				card_reward_array.append(picked_card)
				available_cards.erase(picked_card)
				break

	card_rewards.rewards = card_reward_array
	card_rewards.show()


func _setup_card_chances() -> void:
	card_reward_total_weight = (
		run_stats.common_weight + run_stats.uncommon_weight + run_stats.rare_weight
	)
	card_rarity_weights[Card.Rarity.COMMON] = run_stats.common_weight
	card_rarity_weights[Card.Rarity.UNCOMMON] = run_stats.common_weight + run_stats.uncommon_weight
	card_rarity_weights[Card.Rarity.RARE] = card_reward_total_weight


func _modify_weights(rarity_rolled: Card.Rarity) -> void:
	if rarity_rolled == Card.Rarity.RARE:
		run_stats.rare_weight = RunStats.BASE_RARE_WEIGHT
	else:
		# if we don't roll a rare, we want to increase the chances of getting one
		# so we add 0.3 but clamp it between the base rare weight and 5 max
		run_stats.rare_weight = clampf(run_stats.rare_weight + 0.3, run_stats.BASE_RARE_WEIGHT, 5.0)


func _get_random_available_card(available_cards: Array[Card], with_rarity: Card.Rarity) -> Card:
	var all_possible_cards := available_cards.filter(
		func(card: Card): return card.rarity == with_rarity
	)

	return all_possible_cards.pick_random()


func _on_card_reward_taken(card: Card) -> void:
	if not character_stats_list or not card:
		return

	card.character_stats.deck.add_card(card)
