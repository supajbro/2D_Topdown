extends Node

@export var button_continue_game: 		Button
@export var button_settings: 			Button
@export var button_quit_to_menu: 		Button

func _ready():
	button_continue_game.pressed.connect(_on_play_pressed)
	button_settings.pressed.connect(_on_level_select_pressed)
	button_quit_to_menu.pressed.connect(_on_quit_pressed)

func _on_play_pressed():
	GameStateManager.change_state(GameplayState)

func _on_level_select_pressed():
	GameStateManager.change_state(GameStateManager.GameState.LEVEL_SELECT)

func _on_quit_pressed():
	GameStateManager.change_state(MainMenuState)
	GameplayState.deleta_level_reference()
