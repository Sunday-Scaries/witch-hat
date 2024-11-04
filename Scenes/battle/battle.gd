class_name Battle
extends Node2D

@export var battle_stats: BattleStats
@export var run_startup: RunStartup
@export var music: AudioStream

@onready var battle_ui: BattleUI = $BattleUI
@onready var player_handler: PlayerHandler = %PlayerHandler
@onready var enemy_handler: EnemyHandler = $EnemyHandler

@onready var player_list: Array[Player] = [$Player1, $Player2, $Player3, $Player4]


func _ready() -> void:
	if not run_startup:
		return

	battle_ui.character_stats_list = run_startup.character_list
	for i in run_startup.character_list.size():
		player_list[i].stats = run_startup.character_list[i]

	enemy_handler.child_order_changed.connect(_on_enemies_child_order_changed)
	Events.enemy_turn_ended.connect(_on_enemy_turn_ended)
	Events.player_turn_ended.connect(player_handler.end_turn)
	Events.player_hand_discarded.connect(enemy_handler.start_turn)
	Events.player_died.connect(_on_player_died)

	battle_ui.initialize_card_pile_ui()


func start_battle() -> void:
	get_tree().paused = false
	MusicPlayer.play(music, true)

	enemy_handler.setup_enemies(battle_stats)
	enemy_handler.reset_enemy_actions()
	player_handler.start_battle(run_startup.character_list, player_list)


func _on_enemies_child_order_changed() -> void:
	if enemy_handler.get_child_count() == 0:
		Events.battle_over_screen_requested.emit("Victorious!", BattleOverPanel.Type.WIN)


func _on_enemy_turn_ended() -> void:
	player_handler.start_turn()
	enemy_handler.reset_enemy_actions()


func _on_player_died(player: Player) -> void:
	var index := player_list.find(player)
	player_list.remove_at(index)
	if len(player_list) == 0:
		Events.battle_over_screen_requested.emit("Game Over!", BattleOverPanel.Type.LOSE)
