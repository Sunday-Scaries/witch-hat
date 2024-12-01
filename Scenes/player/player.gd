class_name Player
extends Area2D

const ARROW_OFFSET := 5
const WHITE_SPRITE_MATERIAL := preload("res://art/white_sprite_material.tres")

@export var stats: CharacterStats:
	set = set_character_stats

@onready var arrow: Sprite2D = $Arrow
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var stats_ui: StatsUI = $StatsUI
@onready var status_handler: StatusHandler = $StatusHandler


func _ready() -> void:
	status_handler.status_owner = self


func set_character_stats(value: CharacterStats) -> void:
	stats = value
	# this could be done in a setup function globally but
	# this adds it here as a dependency so you can test it in isolation
	if not stats.stats_changed.is_connected(update_stats):
		stats.stats_changed.connect(update_stats)

	update_player()


func update_player() -> void:
	if not stats is CharacterStats:
		return
	if not is_inside_tree():
		await ready

	sprite_2d.texture = stats.art
	arrow.position = (
		Vector2.RIGHT * ((sprite_2d.get_rect().size.x / 2 + ARROW_OFFSET) * sprite_2d.scale)
	)
	update_stats()


func update_stats() -> void:
	stats_ui.update_stats(stats)


func take_damage(damage: int) -> void:
	if stats.health <= 0:
		return

	sprite_2d.material = WHITE_SPRITE_MATERIAL

	var tween := create_tween()
	tween.tween_callback(Shaker.shake.bind(self, 16, 0.15))
	tween.tween_callback(stats.take_damage.bind(damage))
	tween.tween_interval(0.17)

	tween.finished.connect(_finish_take_damage)


func _finish_take_damage() -> void:
	sprite_2d.material = null

	if stats.health <= 0:
		Events.player_died.emit(self)
		sprite_2d.texture = stats.knocked_out_art


func _on_area_entered(_area) -> void:
	arrow.show()


func _on_area_exited(_area) -> void:
	arrow.hide()
