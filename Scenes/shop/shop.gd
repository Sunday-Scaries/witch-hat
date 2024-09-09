extends Control


func _on_button_pressed():
	Events.shop_exited.emit()
