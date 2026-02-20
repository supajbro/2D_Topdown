class_name weapon_slots
extends UIBase

@export var weapon_slot_01: TextureRect
@export var weapon_slot_02: TextureRect
@export var weapon_slot_03: TextureRect

@export var weapon_slot_01_label: Label
@export var weapon_slot_02_label: Label
@export var weapon_slot_03_label: Label

var WEAPON_SLOTS = [
		WeaponSlot.new(),
		WeaponSlot.new(),
		WeaponSlot.new()
	]

@export var initial_color: 	Color = Color.BLACK
@export var selected_color: Color = Color.YELLOW

var selected_index: int = 0

func _ready():
	super()
	init_weapon_slots()

func init_weapon_slots():
	Global.weapon_slots = self
	
	WEAPON_SLOTS[0].weapon_slot = weapon_slot_01
	WEAPON_SLOTS[1].weapon_slot = weapon_slot_02
	WEAPON_SLOTS[2].weapon_slot = weapon_slot_03
	
	WEAPON_SLOTS[0].label 		= weapon_slot_01_label
	WEAPON_SLOTS[1].label 		= weapon_slot_02_label
	WEAPON_SLOTS[2].label 		= weapon_slot_03_label
	
	# set the initial unselected color & initial selected weapon slot
	for slot in WEAPON_SLOTS:
		slot.weapon_slot.modulate = initial_color
		slot.weapon_type = Global.Gun_Types.INVALID_TYPE
	WEAPON_SLOTS[0].weapon_slot.modulate = selected_color
	#WEAPON_SLOTS[0].weapon_type = Global.Gun_Types.INVALID_TYPE
	
func show_ui():
	super()

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == MOUSE_BUTTON_WHEEL_UP:
			change_weapon(-1)
		elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			change_weapon(1)

func change_weapon(direction: int) -> void:
	select_weapon(WEAPON_SLOTS[selected_index], initial_color)

	selected_index += direction

	if selected_index < 0:
		selected_index = WEAPON_SLOTS.size() - 1
	elif selected_index >= WEAPON_SLOTS.size():
		selected_index = 0

	select_weapon(WEAPON_SLOTS[selected_index], selected_color)
	
func select_weapon(slot: WeaponSlot, color: Color):
	#if Global && Global.GetPlayer() && slot.weapon_type:
	Global.GetPlayer().switch_weapon(slot.weapon_type)
	slot.weapon_slot.modulate = color
	slot.bSelected = true
	
# Adds weapon to slots
func add_weapon(type: Global.Gun_Types):
	for slot in WEAPON_SLOTS:
		if slot.bFilled:
			continue
		slot.add_weapon_to_slot(type, str(type), true)
		
		# If player has no weapons, auto assign the initial one.
		if Global.GetPlayer().selected_weapon == null:
			Global.GetPlayer().switch_weapon(slot.weapon_type)
			
		if(slot.bSelected):
			select_weapon(slot, selected_color)
		break
		
