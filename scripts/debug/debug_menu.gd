extends CanvasLayer
class_name Debug_Menu

# slider scene that modifies value
@export var slider_scene: PackedScene

var tabs := {}

func _ready():
	visible = false
	
func _process(delta: float) -> void:
	if Input.is_key_pressed(KEY_J):
		toggle()

func toggle():
	visible = !visible

func _input(event):
	if event.is_action_pressed("toggle_debug"):
		toggle()

func _get_or_create_tab(tab_name: String) -> VBoxContainer:
	if tabs.has(tab_name):
		return tabs[tab_name]

	var tab_container := $Root/PanelContainer/TabContainer
	var vbox := VBoxContainer.new()
	vbox.name = tab_name
	tab_container.add_child(vbox)

	tabs[tab_name] = vbox
	return vbox


func register_debug_slider(
	tab_name: String,
	label_text: String,
	min_value: float,
	max_value: float,
	initial_value: float,
	on_changed: Callable
):
	var tab := _get_or_create_tab(tab_name)

	var slider := slider_scene.instantiate()
	tab.add_child(slider)

	slider.setup(
		label_text,
		min_value,
		max_value,
		initial_value,
		on_changed
	)
