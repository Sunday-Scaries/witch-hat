class_name MapGenerator
extends Node

#Experiment here for map generation aka inputs for parameters
const X_DIST := 30
const Y_DIST := 25
const PLACEMENT_RANDOMNESS := 5
const FLOORS := 15
const MAP_WIDTH := 7
#Experiement to have one path
const PATHS := 1
#For a dungeon, "weight" of chance
const MONSTER_ROOM_WEIGHT := 10.0
const SHOP_ROOM_WEIGHT := 2.5
const CAMPFIRE_ROOM_WEIGHT := 4.0

var random_room_type_weights = {
	Room.Type.MONSTER: 0.0, Room.Type.CAMPFIRE: 0.0, Room.Type.SHOP: 0.0
}
#Matrix used for looping through map data to boss fight (14,3 could be the boss)
var random_room_type_total_weight := 0
var map_data: Array[Array]


func _ready() -> void:
	generate_map()


#Logic for generating map
func generate_map() -> Array[Array]:
	map_data = _generate_initial_grid()

	# var i := 0
	# for floor in map_data:
	# 	print("floor %s: %s" % [i, floor])
	# 	i += 1

	#TEMPORARY FIX, WANT TO RETURN GENERATED MAP
	return []


func _generate_initial_grid() -> Array[Array]:
	var result: Array[Array] = []
#Loops through number of floors
#Standard matrix: i is row, j is column, code below result var repeats until room is filled
	for i in FLOORS:
		var adjacent_rooms: Array[Room] = []

		for j in MAP_WIDTH:
			var current_room := Room.new()
			var offset := Vector2(randf(), randf() * PLACEMENT_RANDOMNESS)
			#In Godot, -Y means going up
			current_room.position = Vector2(j * X_DIST, i * -Y_DIST) + offset
			current_room.row = i
			current_room.column = j
			current_room.next_rooms = []

			# Boss room must have specific Y
			if i == FLOORS - 1:
				current_room.position.y = (i + 1) * -Y_DIST

			adjacent_rooms.append(current_room)

		result.append(adjacent_rooms)

	return result
