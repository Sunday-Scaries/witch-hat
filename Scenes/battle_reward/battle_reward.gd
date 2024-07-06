extends Control

func _on_button_pressed():
    Events.battle_reward_exited.emit()
