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
	
func show_ui():
	super()

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == MOUSE_BUTTON_WHEEL_UP:
			change_weapon(-1)
		elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			change_weapon(1)

func change_weapon(direction: int) -> void:
	var previous_select_index = selected_index

	selected_index += direction

	if selected_index < 0:
		selected_index = WEAPON_SLOTS.size() - 1
	elif selected_index >= WEAPON_SLOTS.size():
		selected_index = 0
	
	# Make sure next selected slot has a weapon filled.
	var current_attempts = 0
	while !WEAPON_SLOTS[selected_index].bFilled && current_attempts < 3:
		selected_index += direction
		if selected_index < 0:
			selected_index = WEAPON_SLOTS.size() - 1
		elif selected_index >= WEAPON_SLOTS.size():
			selected_index = 0
		current_attempts += 1
	
	var bChange_selected = false
	if WEAPON_SLOTS[selected_index].bFilled:
		bChange_selected = true
		
	if bChange_selected:
		deselect_weapon(WEAPON_SLOTS[previous_select_index], initial_color)
		select_weapon(WEAPON_SLOTS[selected_index], selected_color)
	
func select_weapon(slot: WeaponSlot, color: Color):
	Global.GetPlayer().switch_weapon(slot.weapon_type)
	slot.weapon_slot.modulate = color
	slot.bSelected = true
	
func deselect_weapon(slot: WeaponSlot, color: Color):
	slot.weapon_slot.modulate = color
	slot.bSelected = false
	
# Adds weapon to slots
func add_weapon(type: Global.Gun_Types):
	var bAdd_weapon: bool = true
	
	# Bit jank putting it here but basically search through all slots and see if we
	# tried to pick up an existing weapon and give ammo instead of picking it up (no dups here bud).
	for slot in WEAPON_SLOTS:
		if !slot.bFilled:
			continue
		
		# If we found existing weapon, set the ammo to max for that weapon.
		if slot.weapon_type == type:
			var weapon_found = Global.GetPlayer().weapon_map.get(type)
			weapon_found.current_ammo = weapon_found.max_ammo
			bAdd_weapon = false
			break
	
	# Don't give them a weapon if we already gave them bloody ammo.
	if !bAdd_weapon:
		return	
	
	for slot in WEAPON_SLOTS:
		if slot.bFilled:
			continue
		slot.add_weapon_to_slot(type, str(type), true)
		
		# If player has no weapons, auto assign the initial one.
		if Global.GetPlayer().selected_weapon == null:
			Global.GetPlayer().switch_weapon(slot.weapon_type)
		
		# Max sure when a weapon is picked up - we have max ammo.
		var weapon_found = Global.GetPlayer().weapon_map.get(type)
		weapon_found.current_ammo = weapon_found.max_ammo
		
		if(slot.bSelected):
			select_weapon(slot, selected_color)
		break
		
func remove_weapon(type: Global.Gun_Types):
	for slot in WEAPON_SLOTS:
		if slot.weapon_type != type:
			continue
		slot.remove_weapon_from_slot(type, str(type))
		
		# Make sure player no longer has access to this weapon.
		if Global.GetPlayer() != null && Global.GetPlayer().selected_weapon != null:
			Global.GetPlayer().selected_weapon.set_sprite_visibility(false)
			Global.GetPlayer().selected_weapon = null
		
		deselect_weapon(slot, initial_color)
		break
	# Select the next available slot in the index.
	change_weapon(1)
		
