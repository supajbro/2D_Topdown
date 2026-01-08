extends HBoxContainer
class_name DebugSlider

@onready var label := $Label
@onready var slider := $HSlider
@onready var value_label := $ValueLabel

var callback: Callable

func setup(
	text: String,
	min_value: float,
	max_value: float,
	initial_value: float,
	on_changed: Callable
):
	label.text = text
	slider.min_value = min_value
	slider.max_value = max_value
	slider.value = initial_value
	value_label.text = str(initial_value)

	callback = on_changed
	slider.value_changed.connect(_on_value_changed)

func _on_value_changed(value: float):
	value_label.text = str(round(value))
	if callback:
		callback.call(value)
