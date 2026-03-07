extends Node

var current_state : State

# Set the initial state
func _ready():
	change_state(StartupState)
	
# Run the current states update loop.
func _process(delta: float) -> void:
	if current_state != null:
		current_state.update(delta)

func change_state(new_state: State):
	if current_state == new_state:
		return
	
	# Exit state if there was a previous state.
	if current_state:
		exit_state(current_state)
		
	current_state = new_state
	enter_state(current_state)
	
func enter_state(state: State):
	state.enter()
	
func exit_state(state: State):
	state.exit()
