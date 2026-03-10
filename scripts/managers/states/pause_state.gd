extends State

var pause_scene: 	PackedScene
var pause_instance: Node

var level_to_load 		:= "res://scenes/levels/pause_scene.tscn"
var loading_started 	:= false
var loading_finished 	:= false

func enter():
	super.enter()
	print("Entered Pause State")

	loading_started = false
	loading_finished = false

	# First time pause is opened
	if !loading_started:
		ResourceLoader.load_threaded_request(level_to_load)
		loading_started = true

func exit():
	super.exit()
	print("Exited Pause State")

	if pause_instance:
		pause_instance.hide()

func update(delta):
	super.update(delta)

	if !loading_started or loading_finished:
		return

	var status = ResourceLoader.load_threaded_get_status(level_to_load)

	if status == ResourceLoader.THREAD_LOAD_LOADED:
		pause_scene = ResourceLoader.load_threaded_get(level_to_load)

		pause_instance = pause_scene.instantiate()
		get_tree().root.add_child(pause_instance)

		loading_finished = true
		pause_instance.show()


func handle_input(event):
	super.handle_input(event)
	
	if event.is_action_pressed("Pause"):
		GameStateManager.change_state(GameplayState)
