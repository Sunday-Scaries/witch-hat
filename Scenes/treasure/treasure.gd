extends Control


func _on_button_pressed():
	Events.treasure_room_exited.emit()
