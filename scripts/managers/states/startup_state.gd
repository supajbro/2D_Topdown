extends State

# Debug option to choose where we want the game to autoload into when opening app.
@export var debug_choose_next_state: bool = false

func enter():
	super.enter()
	print("Entered Startup State")
	state_scene = preload("res://scenes/levels/startup_scene.tscn")
	get_tree().change_scene_to_packed(state_scene)
	
	if !debug_choose_next_state:
		GameStateManager.change_state(MainMenuState)
	
func exit():
	super.exit()
	print("Exited Startup State")

func update(delta):
	super.update(delta)
	
func handle_input(event):
	super.handle_input(event)
