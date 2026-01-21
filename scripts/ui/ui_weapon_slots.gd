extends UIBase

@export var weapon_slot_01: TextureRect
@export var weapon_slot_02: TextureRect
@export var weapon_slot_03: TextureRect

@onready var WEAPON_SLOTS: Array[TextureRect] = [
	weapon_slot_01,
	weapon_slot_02,
	weapon_slot_03
]

@export var initial_color: Color = Color.BLACK
@export var selected_color: Color = Color.YELLOW

func _ready():
	super()
	
	# set the initial unselected color
	for c in WEAPON_SLOTS:
		c.modulate = initial_color
	
func show_ui():
	super()
