extends UIBase

@onready var label: Label = $Label

# How long the text stays in the center
const HOLD_TIME := 0.5

# TODO: REMOVE THIS - FOR TESTING ONLY
func _ready():
	super()
	play_wave_complete("Wave Complete")

# Call this to show the wave text animation
func play_wave_complete(text: String):
	# Override because this UI uses text, not image
	label.text = text
	show_ui()

	# Do the whole animation sequence
	_animate_in_out()


func _animate_in_out():
	# Clear any previous tweens
	# TODO: Add this back when finished testing
	#get_tree().create_timer(0.001).timeout

	var tween := create_tween()
	var screen_size = get_viewport_rect().size
	var target_x = screen_size.x * 0.5

	# Step 1: position UI off-screen right
	position.x = screen_size.x

	# Step 2: swipe in to the center
	tween.tween_property(self, "position:x", target_x, 0.4)\
		.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)

	# Step 3: wait in the center
	tween.tween_interval(HOLD_TIME)

	# Step 4: swipe out left
	tween.tween_property(self, "position:x", -size.x, 0.4)\
		.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)

	# Step 5: hide when done
	tween.finished.connect(hide_ui)
