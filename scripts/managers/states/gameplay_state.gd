extends State

var level_instance: Node

func enter():
	super.enter()
	print("Entered Gameplay State")
	
	# If the previous level was to load a level, then load it in here.
	if GameStateManager.previous_state == LoadLevelState:
		level_instance = Global.loaded_level.instantiate()
		get_tree().current_scene.add_child(level_instance)
	
func exit():
	super.exit()
	print("Exited Gameplay State")

func update(delta):
	super.update(delta)
	
func handle_input(event):
	super.handle_input(event)
	
	if event.is_action_pressed("Pause"):
		GameStateManager.change_state(PauseState)
		
func deleta_level_reference():
	if level_instance:
		level_instance.queue_free()
		level_instance = null
		Global.loaded_level = null
