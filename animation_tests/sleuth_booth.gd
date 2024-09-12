extends Node2D

const PATHS = 5
const MAP_WIDTH = 100

var sprite_buggy: Sprite2D
var sprite_fixed: Sprite2D
var timer: Timer
var iteration_count: int = 0
var max_iterations: int = 500  #How many to avoid infinite loop

var fixed_points: Array[int] = []  # Not necessary but AI says good practice
var fixed_done: bool = false  # Finish line for both functions


func _ready():
	# Create sprites
	sprite_buggy = create_sprite(Vector2(100, 100), Color.RED)
	sprite_fixed = create_sprite(Vector2(300, 100), Color.GREEN)

	# Create a timer
	timer = Timer.new()
	timer.wait_time = 0.1  # Update every 0.1 seconds
	timer.connect("timeout", Callable(self, "_on_Timer_timeout"))
	add_child(timer)
	timer.start()

	# Add labels
	add_label("SleuthLabel", Vector2(10, 10), "Sleuth Version")
	add_label("FixedLabel", Vector2(210, 10), "Fixed Version")
	add_label("IterationLabel", Vector2(10, 40), "Iterations: 0")


func create_sprite(pos: Vector2, color: Color) -> Sprite2D:
	var sprite = Sprite2D.new()
	sprite.texture = preload("res://icon.png")  # Use Godot's default icon
	sprite.position = pos
	sprite.modulate = color
	add_child(sprite)
	return sprite


func add_label(label_name: String, pos: Vector2, text: String):
	var label = Label.new()
	label.name = label_name
	label.position = pos
	label.text = text
	add_child(label)


func _on_Timer_timeout():
	if iteration_count >= max_iterations:
		timer.stop()
		print("Okay, you get it.")
		return

	var points_buggy = get_random_starting_points_buggy()

	if not fixed_done:
		fixed_points = get_random_starting_points_fixed()
		if fixed_points.size() >= 2:
			fixed_done = true

	iteration_count += 1

	# Update sprite positions
	if points_buggy.size() > 0:
		sprite_buggy.position.y = points_buggy[0]
	if fixed_points.size() > 0:
		sprite_fixed.position.y = fixed_points[0]

	# Update iteration label
	get_node("IterationLabel").text = "Iterations: " + str(iteration_count)

	# Change sprite colors to visualize updates
	sprite_buggy.modulate = Color(1, 0, 0, randf())  # Red with random alpha
	if not fixed_done:
		sprite_fixed.modulate = Color(0, 0, .75, randf())  # Blue with random alpha
	else:
		sprite_fixed.modulate = Color.SKY_BLUE  # Solid green when done


func get_random_starting_points_buggy() -> Array[int]:
	var y_coordinates: Array[int] = []
	var unique_points: int = 0
	while unique_points < 2:
		unique_points = 0
		y_coordinates = []
		for i in PATHS:
			var starting_point := randi() % MAP_WIDTH
			if not y_coordinates.has(starting_point):
				unique_points += 1
			y_coordinates.append(starting_point)
#I literally don't see a stopping point. Interesting.
	return y_coordinates


func get_random_starting_points_fixed() -> Array[int]:
	var y_coordinates: Array[int] = []
	var unique_points: int = 0
	while unique_points < 2:
		var starting_point := randi() % MAP_WIDTH
		if not y_coordinates.has(starting_point):
			unique_points += 1
			y_coordinates.append(starting_point)
	return y_coordinates
