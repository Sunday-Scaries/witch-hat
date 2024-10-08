class_name Run
extends Node

const MAIN_MENU_SCENE := preload("res://scenes/ui/main_menu.tscn")
const MAIN_MENU_PATH := "res://scenes/ui/main_menu.tscn"
const BATTLE_SCENE := preload("res://scenes/battle/battle.tscn")
const BATTLE_REWARD_SCENE := preload("res://scenes/battle_reward/battle_reward.tscn")
const RIVERS_OF_REFLECTION_SCENE := preload("res://scenes/campfire/rivers_of_reflection.tscn")
const SHOP_SCENE := preload("res://scenes/shop/shop.tscn")
const TREASURE_SCENE := preload("res://scenes/treasure/treasure.tscn")

@export var run_startup: RunStartup
@export var elian: CharacterStats
@export var quixley: CharacterStats
@export var timea: CharacterStats
@export var lionel: CharacterStats
@export var stats: RunStats

@onready var current_view: Node = $CurrentView
@onready var gold_ui: GoldUI = %GoldUI
@onready var map: Map = $Map
@onready var deck_button: CardPileOpener = %DeckButton
@onready var deck_view: CardPileView = %DeckView

# @onready var battle_button: Node = %BattleButton
# @onready var campfire_button: Node = %CampfireButton
# @onready var map_button: Node = %MapButton
# @onready var rewards_button: Node = %RewardsButton
# @onready var shop_button: Node = %ShopButton
# @onready var treasure_button: Node = %TreasureButton
# @onready var menu_button: Node = %MenuButton


func _ready() -> void:
	if not run_startup:
		return

	get_tree().paused = false
	match run_startup.type:
		RunStartup.Type.NEW_RUN:
			_load_characters()
			_start_run()
			map.show_map()

		RunStartup.Type.CONTINUED_RUN:
			print("TODO continue run load data")


func _start_run() -> void:
	stats = RunStats.new()
	_setup_event_connections()
	_setup_top_bar()

	map.generate_new_map()
	map.unlock_floor(0)


func _load_characters() -> void:
	if len(run_startup.character_list) == 0:
		elian = preload("res://characters/elian/elian.tres")
		quixley = preload("res://characters/quixley/quixley.tres")
		timea = preload("res://characters/timea/timea.tres")
		lionel = preload("res://characters/lionel/lionel.tres")

		# starting decks
		var ElianStartingDeck = preload("res://characters/elian/elian_starting_deck.tres")
		var QuixleyStartingDeck = preload("res://characters/quixley/quixley_starting_deck.tres")
		var TimeaStartingDeck = preload("res://characters/timea/timea_starting_deck.tres")
		var LionelStartingDeck = preload("res://characters/lionel/lionel_starting_deck.tres")

		# draftable cards throughout the game
		var ElianDraftableCards = preload("res://characters/elian/elian_draftable_cards.tres")
		var QuixleyDraftableCards = preload("res://characters/quixley/quixley_draftable_cards.tres")
		var TimeaDraftableCards = preload("res://characters/timea/timea_draftable_cards.tres")
		var LionelDraftableCards = preload("res://characters/lionel/lionel_draftable_cards.tres")

		run_startup.elian = elian.create_instance(ElianStartingDeck, ElianDraftableCards)
		run_startup.quixley = quixley.create_instance(QuixleyStartingDeck, QuixleyDraftableCards)
		run_startup.timea = timea.create_instance(TimeaStartingDeck, TimeaDraftableCards)
		run_startup.lionel = lionel.create_instance(LionelStartingDeck, LionelDraftableCards)
		run_startup.update_character_list()


func _setup_top_bar() -> void:
	var combined_deck = _combine_decks()
	deck_button.card_pile = combined_deck
	deck_view.card_pile = combined_deck
	deck_button.pressed.connect(deck_view.show_current_view.bind("Deck"))


func _combine_decks() -> CardPile:
	gold_ui.run_stats = stats
	var combined_deck: CardPile = CardPile.new()
	var deck_arr: Array[CardPile] = []
	for character in run_startup.character_list:
		var char_draw_deck: CardPile = character.deck.duplicate(true)
		deck_arr.append(char_draw_deck)

	for deck in deck_arr:
		for card in deck.cards:
			combined_deck.cards.append(card)

	return combined_deck


func _change_view(scene: PackedScene) -> Node:
	if current_view.get_child_count() > 0:
		current_view.get_child(0).queue_free()

	get_tree().paused = false
	var new_view := scene.instantiate()
	current_view.add_child(new_view)
	map.hide_map()
	# # Hide or show buttons based on the scene
	# if scene in [BATTLE_SCENE, MAIN_MENU_SCENE]:
	# 	_hide_buttons()
	# else:
	# 	_show_buttons()

	return new_view


# func _hide_buttons() -> void:
# 	battle_button.hide()
# 	campfire_button.hide()
# 	map_button.hide()
# 	rewards_button.hide()
# 	shop_button.hide()
# 	treasure_button.hide()
# 	menu_button.hide()

# func _show_buttons() -> void:
# 	battle_button.show()
# 	campfire_button.show()
# 	map_button.show()
# 	rewards_button.show()
# 	shop_button.show()
# 	treasure_button.show()
# 	menu_button.show()


func _show_map() -> void:
	if current_view.get_child_count() > 0:
		current_view.get_child(0).queue_free()

	map.show_map()
	map.unlock_next_rooms()
	# _show_buttons()


func _setup_event_connections() -> void:
	Events.battle_won.connect(_on_battle_won)
	Events.battle_reward_exited.connect(_show_map)
	Events.rivers_of_reflection_exited.connect(_show_map)
	Events.map_exited.connect(_on_map_exited)
	Events.shop_exited.connect(_show_map)
	Events.treasure_room_exited.connect(_show_map)

	# TODO remove debug buttons once done
	# battle_button.pressed.connect(_change_view.bind(BATTLE_SCENE))
	# campfire_button.pressed.connect(_change_view.bind(RIVERS_OF_REFLECTION_SCENE))
	# map_button.pressed.connect(_show_map)
	# rewards_button.pressed.connect(_change_view.bind(BATTLE_REWARD_SCENE))
	# shop_button.pressed.connect(_change_view.bind(SHOP_SCENE))
	# treasure_button.pressed.connect(_change_view.bind(TREASURE_SCENE))
	# menu_button.pressed.connect(_change_view.bind(MAIN_MENU_SCENE))


func _on_battle_won() -> void:
	var reward_scene := _change_view(BATTLE_REWARD_SCENE) as BattleReward
	reward_scene.run_stats = stats
	reward_scene.character_stats_list = run_startup.character_list

	reward_scene.add_gold_reward(map.last_room.battle_stats.roll_gold_reward())
	reward_scene.add_card_reward()


func _on_battle_room_entered(room: Room) -> void:
	var battle_scene: Battle = _change_view(BATTLE_SCENE) as Battle
	battle_scene.battle_stats = room.battle_stats
	battle_scene.start_battle()


func _on_campfire_entered() -> void:
	var campfire := _change_view(RIVERS_OF_REFLECTION_SCENE) as RiversOfReflection
	campfire.char_stats_list = run_startup.character_list


func _on_map_exited(room: Room) -> void:
	match room.type:
		Room.Type.MONSTER:
			_on_battle_room_entered(room)
		Room.Type.TREASURE:
			_change_view(TREASURE_SCENE)
		Room.Type.RIVERS_OF_REFLECTION:
			_on_campfire_entered()
		Room.Type.SHOP:
			_change_view(SHOP_SCENE)
		Room.Type.BOSS:
			_on_battle_room_entered(room)


func _on_game_over() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_packed(MAIN_MENU_SCENE)
