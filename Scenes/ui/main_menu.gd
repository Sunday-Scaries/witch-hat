extends Control

@export var run_startup: RunStartup

@onready var continue_button: Button = %Continue


func _ready() -> void:
	get_tree().paused = false


func _on_exit_pressed():
	get_tree().quit()


func _on_new_run_pressed():
	print("new run")
	run_startup.type = RunStartup.Type.NEW_RUN
	run_startup.character_list.clear()
	get_tree().change_scene_to_file("res://scenes/run/run.tscn")


func _on_continue_pressed():
	print("continue run")
	run_startup.type = RunStartup.Type.CONTINUED_RUN
