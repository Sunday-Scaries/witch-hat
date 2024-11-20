extends Card

@export var optional_sound: AudioStream

var base_damage := 10


func apply_effects(targets: Array[Node], modifiers: ModifierHandler):
	var damage_effect := DamageEffect.new()
	damage_effect.amount = modifiers.get_modified_value(base_damage, Modifier.Type.DMG_DEALT)
	damage_effect.sound = sound
	damage_effect.execute(targets)
	print("TODO this will also have a status effect later")
