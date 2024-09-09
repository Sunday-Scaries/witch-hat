class_name RunStartup
extends Resource

enum Type { NEW_RUN, CONTINUED_RUN }

@export var type: Type
@export var character_list: Array[CharacterStats] = []
@export var elian: CharacterStats
@export var quixley: CharacterStats
@export var timea: CharacterStats
@export var lionel: CharacterStats


func _init():
	# Initialize the character_list when the resource is created
	update_character_list()


func update_character_list():
	character_list.clear()
	if elian:
		character_list.append(elian)
	if quixley:
		character_list.append(quixley)
	if timea:
		character_list.append(timea)
	if lionel:
		character_list.append(lionel)
