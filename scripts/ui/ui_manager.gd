class_name UIManager
extends CanvasLayer

@onready var screens: Control = $Screens
var active_screen: Control = null

const SCREENS = {
	"UI_WAVE_COMPLETE": "ui_wave_complete",
	"UI_PLAYER_HEALTH": "ui_player_health",
	"PAUSE_MENU": "pause_menu",
	"HUD": "hud"
}

func _ready():
	print("Screens:", screens)
	print("Screens children:", screens.get_children())

	hide_all()
	
func show_screen(name: String):
	hide_all()
	
	var screen := screens.get_node_or_null(name)
	if screen is UIBase:
		screen.visible = true
		screen.show_ui()
		active_screen = screens
	else:
		push_error("UI screen not found: " + name)
		
func hide_screen(name: String):
	var screen := screens.get_node_or_null(name)
	if screen:
		screen.visible = false
		if active_screen == screen:
			active_screen = null
	else:
		push_error("UI screen not found: " + name)
		
func hide_all():
	if !screens:
		push_error("You have no UI children!")
		return
	
	for child in screens.get_children():
		if child is Control:
			child.visible = false

# -------------------------
# HELPER FUNCTIONS
# -------------------------
	
func set_screens_text(name: String, text: String):
	var screen := screens.get_node_or_null(name)
	if screen is UIBase:
		screen.set_text(text)
	else:
		push_error("UI screen not found: " + name)
		
func set_screens_slider_value(name: String, value: float):
	var screen := screens.get_node_or_null(name)
	if screen is UIBase:
		screen.set_slider_value(value)
	else:
		push_error("UI screen not found: " + name)
		
func smoothly_set_screens_slider_value(name: String, to_value: float):
	var screen := screens.get_node_or_null(name)
	if screen is UIBase:
		screen.smoothly_set_slider_value(to_value)
	else:
		push_error("UI screen not found: " + name)
			
func is_screen_active(name: String) -> bool:
	var screen := screens.get_node_or_null(name)
	return screen.visible == true
