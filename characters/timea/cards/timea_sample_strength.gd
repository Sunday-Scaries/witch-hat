extends Card

@export var optional_sound: AudioStream


func apply_effects(targets: Array[Node]):
	print("My awesome card has been played!")
	print("Targets: %s" % targets)
