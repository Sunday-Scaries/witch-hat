@tool
extends Control

@export var world_index: int = 1


# Called when the node enters the scene tree for the first time.
func _ready():
	$Label.text = "World" + str(world_index)


# See edits live time.
func _process(delta):
	if Engine.is_editor_hint():
		$Label.text = "World" + str(world_index)
