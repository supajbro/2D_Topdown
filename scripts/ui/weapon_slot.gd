class_name WeaponSlot

var weapon_type: Global.Gun_Types
var weapon_slot: TextureRect
var label: Label
var bSelected: bool 	= false
var bFilled: bool 	= false

var ammo: int 		= -1
var max_ammo: int 	= -1

func add_weapon_to_slot(type: Global.Gun_Types, name: String, _active: bool = false):
	weapon_type = type
	label.text 	= name
	bFilled 	= _active
	
func remove_weapon_from_slot(type: Global.Gun_Types, name: String):
	weapon_type = Global.Gun_Types.INVALID_TYPE
	label.text 	= ""
	bFilled 	= false
