extends State

func enter():
	super.enter()
	print("Entered Main Menu State")
	state_scene = preload("res://scenes/levels/main_menu_scene.tscn")
	get_tree().change_scene_to_packed(state_scene)
	
func exit():
	super.exit()
	print("Exited Main Menu State")

func update(delta):
	super.update(delta)
	
func handle_input(event):
	super.handle_input(event)
