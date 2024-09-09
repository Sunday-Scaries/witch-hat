extends CardState
var played: bool


func enter() -> void:
	played = false

	if not card_ui.targets.is_empty():
		var was_played = card_ui.play()
		if not was_played:
			# TODO this feels like a bad decision but fixes an issue where the
			# card doesn't snap back if not played
			# may need to consider how/where we decide where it isn't played or not
			get_tree().create_timer(0.1)
			transition_requested.emit(self, CardState.State.BASE)
		else:
			played = true


func on_input(_event: InputEvent) -> void:
	if played:
		Events.tooltip_hide_requested.emit()
		return

	transition_requested.emit(self, CardState.State.BASE)
