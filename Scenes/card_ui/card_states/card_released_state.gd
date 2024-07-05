extends CardState
var played: bool

func enter() -> void:
	played = false
	
	print(card_ui.targets)
	if not card_ui.targets.is_empty():
		played = true
		card_ui.play()

func on_input(_event: InputEvent) -> void:
	if played:
		Events.tooltip_hide_requested.emit()
		return
	
	transition_requested.emit(self, CardState.State.BASE)
