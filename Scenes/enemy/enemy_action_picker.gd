class_name EnemyActionPicker
extends Node

@export var enemy: Enemy:
	set = _set_enemy
@export var targets: Array[Player]
# TODO make more flexible to target enemies for confusion
@export var target: Player:
	set = _set_target

@onready var total_weight := 0.0


func _ready() -> void:
	var temp := get_tree().get_nodes_in_group("player") as Array[Node]
	for i in temp:
		if i is Player:
			targets.append(i)

	setup_chances()


func get_action() -> EnemyAction:
	# TODO this could probably be tweaked as the enemy gets more hurt or other conditions
	# TODO once summons are a thing, target will be forced to be that
	var living_targets = targets.filter(func(player: Player): return player.stats.health > 0)
	target = living_targets.pick_random()

	var action := get_first_conditional_action()
	if action:
		return action

	return get_chance_based_action()


func get_first_conditional_action() -> EnemyAction:
	for action: EnemyAction in get_children():
		if not action or action.type != EnemyAction.Type.CONDITIONAL:
			continue

		if action.is_performable():
			return action

	return null


func get_chance_based_action() -> EnemyAction:
	var roll := randf_range(0.0, total_weight)

	for action: EnemyAction in get_children():
		if not action or action.type != EnemyAction.Type.CHANCE_BASED:
			continue

		if action.accumulated_weight > roll:
			return action

	return null


func setup_chances() -> void:
	for action: EnemyAction in get_children():
		if not action or action.type != EnemyAction.Type.CHANCE_BASED:
			continue

		total_weight += action.chance_weight
		action.accumulated_weight = total_weight


func _set_enemy(value: Enemy) -> void:
	enemy = value

	for action: EnemyAction in get_children():
		action.enemy = enemy


func _set_target(value: Player) -> void:
	target = value

	for action: EnemyAction in get_children():
		action.target = target
