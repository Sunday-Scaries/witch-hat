class_name BattleUI
extends CanvasLayer

@export var character_stats_list: Array[CharacterStats]:
	set = _set_character_stats_list

@onready var hand: Hand = $Hand
@onready var mana_ui1: ManaUI = $ManaUI
@onready var mana_ui2: ManaUI = $ManaUI2
@onready var mana_ui3: ManaUI = $ManaUI3
@onready var mana_ui4: ManaUI = $ManaUI4
@onready var end_turn_button: Button = %EndTurnButton
@onready var mana_ui_list: Array[ManaUI] = [mana_ui1, mana_ui2, mana_ui3, mana_ui4]
@onready var draw_pile_button: CardPileOpener = %DrawPileButton
@onready var discard_pile_button: CardPileOpener = %DiscardPileButton
@onready var draw_pile_view: CardPileView = %DrawPileView
@onready var discard_pile_view: CardPileView = %DiscardPileView
@onready var player_handler: PlayerHandler = %PlayerHandler


func _ready() -> void:
	Events.player_hand_drawn.connect(_on_player_hand_drawn)
	end_turn_button.pressed.connect(_on_end_turn_button_pressed)
	var randomized := true
	draw_pile_button.pressed.connect(draw_pile_view.show_current_view.bind("Draw Pile", randomized))
	discard_pile_button.pressed.connect(discard_pile_view.show_current_view.bind("Discard Pile"))


func initialize_card_pile_ui() -> void:
	draw_pile_button.card_pile = player_handler.draw_pile
	draw_pile_view.card_pile = player_handler.draw_pile
	discard_pile_button.card_pile = player_handler.discard
	discard_pile_view.card_pile = player_handler.discard


func _set_character_stats_list(value: Array[CharacterStats]) -> void:
	character_stats_list = value
	for i in character_stats_list.size():
		mana_ui_list[i].char_stats = character_stats_list[i]


func _on_player_hand_drawn() -> void:
	end_turn_button.disabled = false


func _on_end_turn_button_pressed() -> void:
	end_turn_button.disabled = true
	Events.player_turn_ended.emit()
