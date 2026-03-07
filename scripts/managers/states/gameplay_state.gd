extends State

var level_to_load: String = "res://scenes/levels/test_enemy_pathfinding.tscn"
var loading_started := false

func enter():
	super.enter()
	print("Entered Gameplay State")
	var level = Global.loaded_level.instantiate()
	get_tree().current_scene.add_child(level)
	
func exit():
	super.exit()
	print("Exited Gameplay State")

func update(delta):
	super.update(delta)
	
func handle_input(event):
	super.handle_input(event)
