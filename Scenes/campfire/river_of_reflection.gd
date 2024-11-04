class_name RiverOfReflection
extends Node2D

@export var char_stats_list: Array[CharacterStats]

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var ui: Control = $Player/Camera2D/UI


func _on_rest_button_pressed() -> void:
	for character in char_stats_list:
		character.heal(ceili(character.max_health * 0.3))
	ui.hide()
	animation_player.play("fade_out")


# This is called from the AnimationPLayer at the end of "fade_out"
func _on_fade_out_finished() -> void:
	Events.rivers_of_reflection_exited.emit()


func _on_rest_spot_body_entered(_body) -> void:
	ui.show()


func _on_rest_spot_body_exited(_body) -> void:
	ui.hide()
