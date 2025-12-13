class_name UIBase
extends Control

@export var icon: Texture2D
@onready var icon_node: TextureRect = $IconRect

func _ready():
	if icon_node and icon:
		icon_node.texture = icon

func show_ui():
	visible = true

func hide_ui():
	visible = false

func toggle_ui():
	visible = not visible

func set_icon(tex: Texture2D):
	icon = tex
	if icon_node:
		icon_node.texture = tex

# Empty func so classes that require text can easily set their text
func set_text(text: String):
	pass
	
# Empty func so classes that require sliders can easily set their slider value
func set_slider_value(value: float):
	pass
	
# Empty func so classes that require sliders can easily set their slider value smoothly
var to_value_slider: float = -1
func smoothly_set_slider_value(to_value: float):
	to_value_slider = to_value
	
# animations
func fade_in():
	modulate.a = 0.0
	visible = true
	create_tween().tween_property(self, "modulate:a", 1.0, 0.25)

func fade_out():
	create_tween().tween_property(self, "modulate:a", 0.0, 0.25).finished.connect(hide_ui)
