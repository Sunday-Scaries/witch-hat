extends CardState


func enter() -> void:
	if not card_ui.is_node_ready():
		await card_ui.ready

	if card_ui.tween and card_ui.tween.is_running():
		card_ui.tween.kill()

	card_ui.reparent_requested.emit(card_ui)
	card_ui.pivot_offset = Vector2.ZERO
	Events.tooltip_hide_requested.emit()


func on_gui_input(event: InputEvent) -> void:
	if not card_ui.playable or card_ui.disabled:
		return

	if event.is_action_pressed("left_mouse"):
		card_ui.pivot_offset = card_ui.get_global_mouse_position() - card_ui.global_position
		transition_requested.emit(self, CardState.State.CLICKED)


func on_mouse_entered() -> void:
	if not card_ui.playable or card_ui.disabled:
		return

	var color_hover = Color(0.757, 0.714, 0.388)
	var sb = card_ui.panel.get_theme_stylebox("panel").duplicate()
	sb.border_color = color_hover
	sb.set_border_width_all(2)
	card_ui.panel.add_theme_stylebox_override("panel", sb)
	Events.card_tooltip_requested.emit(card_ui.card.icon, card_ui.card.tooltip_text)


func on_mouse_exited() -> void:
	if not card_ui.playable or card_ui.disabled:
		return

	var color_base = Color(0, 0, 0, 1)
	var sb = card_ui.panel.get_theme_stylebox("panel").duplicate()
	sb.border_color = color_base
	sb.set_border_width_all(0)
	card_ui.panel.add_theme_stylebox_override("panel", sb)

	Events.tooltip_hide_requested.emit()
