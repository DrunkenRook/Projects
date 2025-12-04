extends Node

var current_area = 1
var area_path = "res://assets/scenes/areas/"
var keys = 0

func _ready():
	set_up_area()

func next_level():
	current_area += 1
	var full_path = area_path + "area_" + str(current_area) + ".tscn"
	get_tree().change_scene_to_file(full_path)
	set_up_area()

func gameover():
	get_tree().change_scene_to_file("res://assets/scenes/areas/gameover_screen")

func set_up_area():
	pass
	#reset_keys()

func add_key():
	keys += 1
	if keys >= 3:
		var exit = get_tree().get_first_node_in_group("Exits") as ExitTrigger
		exit.open()

func reset_keys():
	keys = 0
