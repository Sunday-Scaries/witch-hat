@tool
@icon("res://assets/dialogue_item_icon.svg")
class_name DialogueItem extends SlideShowEntry

@export_group("Choices")
## An array of choices. Each choice will become a button in the interface
@export var choices: Array[DialogueChoice] = []:
	set = set_choices


## Setter for the [param choices] property. Ensures the choices array never has
## an empty element.
func set_choices(new_choices: Array[DialogueChoice]) -> void:
	for index in new_choices.size():
		if new_choices[index] == null:
			new_choices[index] = DialogueChoice.new()
	choices = new_choices
