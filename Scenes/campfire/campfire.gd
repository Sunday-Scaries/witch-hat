class_name Campfire
extends Control

@export var char_stats_list: Array[CharacterStats]

@onready var animation_player: AnimationPlayer = $AnimationPlayer


func _on_rest_button_pressed() -> void:
	for character in char_stats_list:
		print(character)
		print(character.health)
		character.heal(ceili(character.max_health * 0.3))
		print(character.health)
	animation_player.play("fade_out")


# This is called from the AnimationPLayer at the end of "fade_out"
func _on_fade_out_finished() -> void:
	Events.campfire_exited.emit()
