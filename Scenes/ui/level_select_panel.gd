class_name LevelSelectPanel
extends Control

var room: MapRoom

@onready var continue_button: Button = %ContinueButton


func _ready() -> void:
	continue_button.pressed.connect(_handle_continue)
	Events.room_enter_requested.connect(toggle_screen)


func toggle_screen(room_to_set: MapRoom) -> void:
	if room_to_set:
		room = room_to_set
		show()
	else:
		hide()


func _handle_exit() -> void:
	hide()


func _handle_continue() -> void:
	room.enter_room()
	hide()
