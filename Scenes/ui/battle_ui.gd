class_name BattleUI
extends CanvasLayer

@export var char1_stats: CharacterStats: set = _set_char1_stats
@export var char2_stats: CharacterStats: set = _set_char2_stats
@export var char3_stats: CharacterStats: set = _set_char3_stats
@export var char4_stats: CharacterStats: set = _set_char4_stats
@export var character_stats_list: Array[CharacterStats]: set = _set_character_stats_list

@onready var hand: Hand = $Hand
@onready var mana_ui: ManaUI = $ManaUI
@onready var end_turn_button: Button = %EndTurnButton

func _ready() -> void:
	Events.player_hand_drawn.connect(_on_player_hand_drawn)
	end_turn_button.pressed.connect(_on_end_turn_button_pressed)

func _set_char1_stats(value: CharacterStats) -> void:
	char1_stats = value
	# TODO fix this setup
	mana_ui.char_stats = char1_stats
	hand.char_stats = char1_stats

func _set_char2_stats(value: CharacterStats) -> void:
	char2_stats = value
	# mana_ui.char_stats = char2_stats
	# hand.char_stats = char2_stats

func _set_char3_stats(value: CharacterStats) -> void:
	char3_stats = value
	# mana_ui.char_stats = char3_stats
	# hand.char_stats = char3_stats

func _set_char4_stats(value: CharacterStats) -> void:
	char4_stats = value
	# mana_ui.char_stats = char4_stats
	# hand.char_stats = char4_stats

func _set_character_stats_list(value: Array[CharacterStats]) -> void:
	character_stats_list = value
	# TODO fix this to be for multiple chars
	mana_ui.char_stats = character_stats_list[0]
	hand.char_stats = character_stats_list[0]

func _on_player_hand_drawn() -> void:
	end_turn_button.disabled = false

func _on_end_turn_button_pressed() -> void:
	end_turn_button.disabled = true
	Events.player_turn_ended.emit()
