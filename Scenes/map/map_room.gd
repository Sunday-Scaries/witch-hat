class_name MapRoom
extends Area2D

signal selected(room: Room)

const ICONS := {
	Room.Type.NOT_ASSIGNED: [null, Vector2.ONE],
	Room.Type.MONSTER: [preload("res://art/tile_0103.png"), Vector2(3.0, 3.0)],
	Room.Type.TREASURE: [preload("res://art/tile_0089.png"), Vector2(3.0, 3.0)],
	Room.Type.RIVERS_OF_REFLECTION: [preload("res://art/player_heart.png"), Vector2(2.0, 2.0)],
	Room.Type.SHOP: [preload("res://art/gold.png"), Vector2(2.0, 2.0)],
	Room.Type.BOSS: [preload("res://art/tile_0105.png"), Vector2(5.25, 5.25)],
}

var available := false:
	set = set_available
var room: Room:
	set = set_room

@onready var sprite_2d: Sprite2D = $Visuals/Sprite2D
@onready var line_2d: Line2D = $Visuals/Line2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer


func set_available(new_value: bool) -> void:
	available = new_value

	if available:
		animation_player.play("highlight")
	elif not room.selected:
		animation_player.play("RESET")


func set_room(new_data: Room) -> void:
	room = new_data
	position = room.position
	line_2d.rotation_degrees = randi_range(0, 360)
	sprite_2d.texture = ICONS[room.type][0]
	sprite_2d.scale = ICONS[room.type][1]


func show_selected() -> void:
	line_2d.modulate = Color.WHITE


func _on_input_event(_viewport: Node, event: InputEvent, _shape_idx: int):
	if not available or not event.is_action_pressed("left_mouse"):
		return

	room.selected = true
	animation_player.play("select")


# called by the AnimationPlayer when the select animation finishes
func _on_map_room_selected() -> void:
	selected.emit(room)


func enter_room() -> void:
	room.selected = true
	animation_player.play("select")


func _on_body_entered(_body: Node2D):
	if available and not room.selected:
		Events.room_enter_requested.emit(self)


func _on_body_exited(_body: Node2D):
	Events.room_enter_requested.emit(null)
