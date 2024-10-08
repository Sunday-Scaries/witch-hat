class_name Room
extends Resource

enum Type { NOT_ASSIGNED, MONSTER, TREASURE, RIVERS_OF_REFLECTION, SHOP, BOSS }

@export var type: Type
@export var row: int
@export var column: int
@export var position: Vector2
@export var next_rooms: Array[Room]
@export var selected := false
# this is only used by the MONSTER and BOSS room types
@export var battle_stats: BattleStats


func _to_string() -> String:
	return "%s (%s)" % [column, Type.keys()[type][0]]
