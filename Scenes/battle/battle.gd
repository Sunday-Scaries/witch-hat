extends Node2D

@export var char1_stats: CharacterStats
@export var char2_stats: CharacterStats
@export var char3_stats: CharacterStats
@export var char4_stats: CharacterStats
@export var music: AudioStream

@onready var battle_ui: BattleUI = $BattleUI
@onready var player_handler: PlayerHandler = $PlayerHandler
@onready var enemy_handler: EnemyHandler = $EnemyHandler
@onready var player1: Player = $Player
@onready var player2: Player = $Player2
@onready var player3: Player = $Player3
@onready var player4: Player = $Player4

func _ready() -> void:
	# Normally, we would do this on a 'Run'
	# level so we keep our health, gold and deck
	# between battles.
	# this will change long term since this makes it scoped to 1 battle
	var new_stats1: CharacterStats = char1_stats.create_instance()
	battle_ui.char1_stats = new_stats1
	player1.stats = new_stats1
	
	var new_stats2: CharacterStats = char2_stats.create_instance()
	battle_ui.char2_stats = new_stats2
	player2.stats = new_stats2
	
	var new_stats3: CharacterStats = char3_stats.create_instance()
	battle_ui.char3_stats = new_stats3
	player3.stats = new_stats3

	var new_stats4: CharacterStats = char4_stats.create_instance()
	battle_ui.char4_stats = new_stats4
	player4.stats = new_stats4
	
	enemy_handler.child_order_changed.connect(_on_enemies_child_order_changed)
	Events.enemy_turn_ended.connect(_on_enemy_turn_ended)
	Events.player_turn_ended.connect(player_handler.end_turn)
	Events.player_hand_discarded.connect(enemy_handler.start_turn)
	Events.player_died.connect(_on_player_died)
	
	var stats_arr: Array[CharacterStats] = [new_stats1, new_stats2, new_stats3, new_stats4]
	start_battle(stats_arr)

func start_battle(stats: Array[CharacterStats]) -> void:
	get_tree().paused = false
	MusicPlayer.play(music, true)
	enemy_handler.reset_enemy_actions()
	player_handler.start_battle(stats)

func _on_enemies_child_order_changed() -> void:
	if enemy_handler.get_child_count() == 0:
		Events.battle_over_screen_requested.emit("Victorious!", BattleOverPanel.Type.WIN)

func _on_enemy_turn_ended() -> void:
	player_handler.start_turn()
	enemy_handler.reset_enemy_actions()

func _on_player_died() -> void:
	Events.battle_over_screen_requested.emit("Game Over!", BattleOverPanel.Type.LOSE)
