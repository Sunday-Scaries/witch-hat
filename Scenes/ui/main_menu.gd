extends Control

const RUN_SCENE = preload ("res://scenes/run/run.tscn")
@onready var continue_button: Button = %Continue

@export var run_startup: RunStartup

func _ready() -> void:
    get_tree().paused = false

func _on_exit_pressed():
    get_tree().quit()

func _on_new_run_pressed():
    print("new run")
    run_startup.type = RunStartup.Type.NEW_RUN
    get_tree().change_scene_to_packed(RUN_SCENE)

func _on_continue_pressed():
    print("continue run")
    run_startup.type = RunStartup.Type.CONTINUED_RUN
