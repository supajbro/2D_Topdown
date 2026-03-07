extends Node

@export var play_game_button: 		Button
@export var level_select_button: 	Button
@export var quit_game_button: 		Button

func _ready():
	play_game_button.pressed.connect(_on_play_pressed)

func _on_play_pressed():
	GameStateManager.change_state(LoadLevelState)

func _on_level_select_pressed():
	GameStateManager.change_state(GameStateManager.GameState.LEVEL_SELECT)

func _on_quit_pressed():
	get_tree().quit()
