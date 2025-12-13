extends UIBase

@onready var slider: HSlider = $player_slider

# How long the text stays in the center
const HOLD_TIME := 0.5
const SPEED = 100

func _ready():
	super()
	
func _process(delta: float):
	if to_value_slider == -1:
		return
	slider.value = move_toward(slider.value, to_value_slider, SPEED * delta)
	
func show_ui():
	super()
	
func set_slider_value(value: float):
	slider.value = value
