class_name BattleUI
extends CanvasLayer

@export var character_stats_list: Array[CharacterStats]: set = _set_character_stats_list

@onready var hand: Hand = $Hand
@onready var mana_ui1: ManaUI = $ManaUI
@onready var mana_ui2: ManaUI = $ManaUI2
@onready var mana_ui3: ManaUI = $ManaUI3
@onready var mana_ui4: ManaUI = $ManaUI4
@onready var end_turn_button: Button = %EndTurnButton
@onready var mana_ui_list: Array[ManaUI] = [mana_ui1, mana_ui2, mana_ui3, mana_ui4]

func _ready() -> void:
	Events.player_hand_drawn.connect(_on_player_hand_drawn)
	end_turn_button.pressed.connect(_on_end_turn_button_pressed)

func _set_character_stats_list(value: Array[CharacterStats]) -> void:
	# TODO need to refactor this. Right now the 2nd time you start the battle, it gets 8 instead of 4 items to start
	# there's probably a much smarter way to do what i'm doing with the 4 players
	character_stats_list = value
	for i in character_stats_list.size():
		mana_ui_list[i].char_stats = character_stats_list[i]

	# TODO fix the hand setup? 
	hand.char_stats = character_stats_list[0]

func _on_player_hand_drawn() -> void:
	end_turn_button.disabled = false

func _on_end_turn_button_pressed() -> void:
	end_turn_button.disabled = true
	Events.player_turn_ended.emit()
