class_name SlideShowEntry extends Resource
@export_group("Images")
## Represents the character's expression for this dialogue bubble
@export var expression := preload("res://art/tutorials/dialogue/emotion_regular.png")
## Represents the character's body for this dialogue bubble
@export var character := preload("res://art/tutorials/dialogue/sophia.png")

@export_group("Text")
## The text of this dialogue bubble
@export_multiline var text := ""
