extends Control

func _on_button_pressed():
	Events.map_exited.emit()
