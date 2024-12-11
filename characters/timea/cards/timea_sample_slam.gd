extends Card

const EXPOSED_STATUS := preload("res://statuses/exposed.tres")
@export var optional_sound: AudioStream

var base_damage := 4
var exposed_duration := 2


func apply_effects(targets: Array[Node], modifiers: ModifierHandler):
	var damage_effect := DamageEffect.new()
	damage_effect.amount = modifiers.get_modified_value(base_damage, Modifier.Type.DMG_DEALT)
	damage_effect.sound = sound
	damage_effect.execute(targets)

	var status_effect := StatusEffect.new()
	var exposed := EXPOSED_STATUS.duplicate()
	exposed.duration = exposed_duration
	status_effect.status = exposed
	status_effect.execute(targets)


func get_default_tooltip() -> String:
	return tooltip_text % base_damage


func get_updated_tooltip(
	player_modifiers: ModifierHandler, enemy_modifiers: ModifierHandler
) -> String:
	var modified_dmg := player_modifiers.get_modified_value(base_damage, Modifier.Type.DMG_DEALT)

	if enemy_modifiers:
		modified_dmg = enemy_modifiers.get_modified_value(modified_dmg, Modifier.Type.DMG_TAKEN)

	return tooltip_text % modified_dmg
