extends Card


# NOTE card.gd has a virtualized method for this and this implements it since
# it extends from Card
func apply_effects(targets: Array[Node]) -> void:
	var damage_effect := DamageEffect.new()
	damage_effect.amount = 6
	damage_effect.sound = sound
	damage_effect.execute(targets)
