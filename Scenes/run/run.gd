class_name Run
extends Node

const MAIN_MENU_SCENE := preload ("res://scenes/ui/main_menu.tscn")
const BATTLE_SCENE := preload ("res://scenes/battle/battle.tscn")
const BATTLE_REWARD_SCENE := preload ("res://scenes/battle_reward/battle_reward.tscn")
const CAMPFIRE_SCENE := preload ("res://scenes/campfire/campfire.tscn")
const MAP_SCENE := preload ("res://scenes/map/map.tscn")
const SHOP_SCENE := preload ("res://scenes/shop/shop.tscn")
const TREASURE_SCENE := preload ("res://scenes/treasure/treasure.tscn")

@export var run_startup: RunStartup
@export var char1_stats: CharacterStats
@export var char2_stats: CharacterStats
@export var char3_stats: CharacterStats
@export var char4_stats: CharacterStats

@onready var current_view: Node = $CurrentView
@onready var battle_button: Node = %BattleButton
@onready var campfire_button: Node = %CampfireButton
@onready var map_button: Node = %MapButton
@onready var rewards_button: Node = %RewardsButton
@onready var shop_button: Node = %ShopButton
@onready var treasure_button: Node = %TreasureButton

func _ready() -> void:
	if not run_startup:
		return

	get_tree().paused = false
	match run_startup.type:
		RunStartup.Type.NEW_RUN:
			_load_characters()
			_start_run()
			print("startup ready", run_startup.character_list)

		RunStartup.Type.CONTINUED_RUN:
			print("TODO continue run load data")

func _start_run() -> void:
	_setup_event_connections()
	print("TODO procedurally generate map")

func _load_characters() -> void:
	# TODO maybe i can get rid of the char1_stats variables?
	var new_stats1: CharacterStats = char1_stats.create_instance()
	run_startup.character_list.append(new_stats1)
	
	var new_stats2: CharacterStats = char2_stats.create_instance()
	run_startup.character_list.append(new_stats2)
	
	var new_stats3: CharacterStats = char3_stats.create_instance()
	run_startup.character_list.append(new_stats3)

	var new_stats4: CharacterStats = char4_stats.create_instance()
	run_startup.character_list.append(new_stats4)

func _change_view(scene: PackedScene) -> void:
	if current_view.get_child_count() > 0:
		current_view.get_child(0).queue_free()

	get_tree().paused = false
	var new_view := scene.instantiate()
	current_view.add_child(new_view)

	# Hide or show buttons based on the scene
	if scene in [BATTLE_SCENE, MAIN_MENU_SCENE]:
		_hide_buttons()
	else:
		_show_buttons()

func _hide_buttons() -> void:
	battle_button.hide()
	campfire_button.hide()
	map_button.hide()
	rewards_button.hide()
	shop_button.hide()
	treasure_button.hide()

func _show_buttons() -> void:
	battle_button.show()
	campfire_button.show()
	map_button.show()
	rewards_button.show()
	shop_button.show()
	treasure_button.show()

func _setup_event_connections() -> void:
	Events.battle_won.connect(_change_view.bind(BATTLE_REWARD_SCENE))
	Events.battle_reward_exited.connect(_change_view.bind(MAP_SCENE))
	Events.campfire_exited.connect(_change_view.bind(MAP_SCENE))
	Events.map_exited.connect(_change_view.bind(_on_map_exited))
	Events.shop_exited.connect(_change_view.bind(MAP_SCENE))
	Events.treasure_room_exited.connect(_change_view.bind(MAP_SCENE))
	Events.game_over.connect(_change_view.bind(MAIN_MENU_SCENE))

	# TODO remove debug buttons once done
	battle_button.pressed.connect(_change_view.bind(BATTLE_SCENE))
	campfire_button.pressed.connect(_change_view.bind(CAMPFIRE_SCENE))
	map_button.pressed.connect(_change_view.bind(MAP_SCENE))
	rewards_button.pressed.connect(_change_view.bind(BATTLE_REWARD_SCENE))
	shop_button.pressed.connect(_change_view.bind(SHOP_SCENE))
	treasure_button.pressed.connect(_change_view.bind(TREASURE_SCENE))

func _on_map_exited() -> void:
	print("TODO: from the MAP, change view based on room type")
