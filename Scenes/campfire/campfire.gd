extends Control

func _on_button_pressed():
	Events.campfire_exited.emit()
