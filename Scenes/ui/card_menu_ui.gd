class_name CardMenuUI
extends CenterContainer

signal tooltip_requested(card: Card)

const BASE_STYLEBOX := preload("res://scenes/card_ui/card_base_stylebox.tres")
const HOVER_STYLEBOX := preload("res://scenes/card_ui/card_hover_stylebox.tres")

@export var card: Card:
	set = set_card
@export var char_stats: CharacterStats:
	set = _set_char_stats

@onready var panel: Panel = $Visuals/Panel
@onready var cost: Label = $Visuals/Cost
@onready var icon: TextureRect = $Visuals/Icon


func _on_visuals_gui_input(event: InputEvent) -> void:
	if event.is_action_pressed("left_mouse"):
		tooltip_requested.emit(card)


#TODO hover state?
# func _on_visuals_mouse_entered():
# 	panel.set("theme_override_styles/panel", HOVER_STYLEBOX)

# func _on_visuals_mouse_exited():
# 	panel.set("theme_override_styles/panel", BASE_STYLEBOX)


func set_card(value: Card) -> void:
	if not is_node_ready():
		await ready

	card = value
	cost.text = str(card.cost)
	icon.texture = card.icon
	if char_stats:
		panel.set("theme_override_styles/panel", char_stats.theme)


func _set_char_stats(value: CharacterStats) -> void:
	char_stats = value
