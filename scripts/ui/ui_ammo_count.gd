extends UIBase

@onready var label: Label = $Label

func _ready():
	super()
	label.text = ""
	
func show_ui():
	super()
	
func _process(delta: float) -> void:
	if visible == false || Global.GetPlayer() == null:
		return
		
	# Hide the ammo count when no weapon is held.
	if Global.GetPlayer().selected_weapon == null:
		if label.text != "":
			label.text = ""
		return
		
	var weapon = Global.GetPlayer().selected_weapon
	set_text(str(weapon.current_ammo) + "/" + str(weapon.max_ammo))
	
func set_text(text: String):
	label.text = text
