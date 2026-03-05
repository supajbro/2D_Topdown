extends Node

var current_state : State

# Set the initial state
func _ready():
	change_state(StartupState)

func change_state(new_state: State):
	if current_state == new_state:
		return
	exit_state(current_state)
	current_state = new_state
	enter_state(current_state)
	
func enter_state(state: State):
	state.enter()
	
func exit_state(state: State):
	state.exit()
