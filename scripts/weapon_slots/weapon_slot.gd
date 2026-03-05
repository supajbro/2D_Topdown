class_name WeaponSlot
extends TextureRect

var weapon_type: 			Global.Gun_Types
@export var weapon_slot: 	TextureRect
var bSelected: bool 		= false
var bFilled: bool 			= false

var ammo: int 		= -1
var max_ammo: int 	= -1

@export var weapon_slot_pistol: 			TextureRect
@export var weapon_slot_shotgun: 			TextureRect
@export var weapon_slot_machine_gun: 		TextureRect
@export var weapon_slot_rocket_launcher: 	TextureRect
var weapon_slots := {}

func weapon_slot_init():
	weapon_slots = {
		Global.Gun_Types.PISTOL: 			weapon_slot_pistol,
		Global.Gun_Types.SHOTGUN: 			weapon_slot_shotgun,
		Global.Gun_Types.MACHINE_GUN: 		weapon_slot_machine_gun,
		Global.Gun_Types.ROCKET_LAUNCHER: 	weapon_slot_rocket_launcher
	}
	for slot in weapon_slots.values():
		slot.visible = false

# We now have this item in our inventory.
func add_weapon_to_slot(type: Global.Gun_Types, name: String, _active: bool = false):
	weapon_type 				= type
	bFilled 					= _active
	weapon_slots[type].visible 	= true
	
# When player drops when or ammo is depleted.
func remove_weapon_from_slot(type: Global.Gun_Types, name: String):
	weapon_type 				= Global.Gun_Types.INVALID_TYPE
	bFilled 					= false
	weapon_slots[type].visible 	= false
