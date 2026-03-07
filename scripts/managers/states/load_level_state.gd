extends State

# TODO: This will need to change to remember level we are up to
var level_to_load: String = "res://scenes/levels/test_enemy_pathfinding.tscn"
var loading_started := false

func enter():
	super.enter()
	print("Entered Load Level State")
	state_scene = preload("res://scenes/levels/load_level_scene.tscn")
	get_tree().change_scene_to_packed(state_scene)
	
	# start async loading
	ResourceLoader.load_threaded_request(level_to_load)
	loading_started = true
	
func exit():
	super.exit()
	print("Exited Load Level State")
	loading_started = false

func update(delta):
	super.update(delta)

	if !loading_started:
		return

	var status = ResourceLoader.load_threaded_get_status(level_to_load)

	if status == ResourceLoader.THREAD_LOAD_LOADED:
		var level_scene = ResourceLoader.load_threaded_get(level_to_load)
		Global.loaded_level = level_scene
		GameStateManager.change_state(GameplayState)
	
func handle_input(event):
	super.handle_input(event)
