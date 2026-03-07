extends Node

var loaded_level: PackedScene

var player: player = null
var cam: player_camera = null
var enemy_spawner: enemy_spawner = null
var weapon_slots: weapon_slots = null

# -------------------------
# GLOBAL ENEMIES
# -------------------------

enum Enemy_Types
{
	SHOOTING = 0,
	EXPLODING,
	INVALID_TYPE
}

# -------------------------
# GLOBAL GUN
# -------------------------

enum Gun_Types
{
	PISTOL = 0,
	MACHINE_GUN,
	SHOTGUN,
	ROCKET_LAUNCHER,
	INVALID_TYPE
}

@export var gun_weights := {
	Gun_Types.PISTOL: 50,
	Gun_Types.MACHINE_GUN: 30,
	Gun_Types.SHOTGUN: 15,
	Gun_Types.ROCKET_LAUNCHER: 5
}

func get_random_gun() -> Gun_Types:
	var total_weight := 0
	for weight in gun_weights.values():
		total_weight += weight

	var roll := rng.randi_range(1, total_weight)
	var running := 0

	for gun_type in gun_weights.keys():
		running += gun_weights[gun_type]
		if roll <= running:
			return gun_type

	return Gun_Types.INVALID_TYPE

@export_range(0, 100) var gun_drop_chance := 50

func enemy_should_drop_gun() -> bool:
	return rng.randf() * 100.0 < gun_drop_chance


# -------------------------
# GLOBAL RNG
# -------------------------

# Global RNG for this script
var rng := RandomNumberGenerator.new()
func _ready():
	rng.seed = randi() % 1000000000  # 0 to 999,999,999
	rng.randomize()
	print(rng.seed)
	
# -------------------------
# GETTERS
# -------------------------

func GetPlayer() -> player:
	if(player == null):
		push_error("Missing ref to player")
	return player

func GetCamera() -> player_camera:
	if(cam == null):
		push_error("Missing ref to camera")
	return cam
	
func GetEnemySpawner() -> enemy_spawner:
	if(enemy_spawner == null):
		push_error("Missing ref to enemy spawner")
	return enemy_spawner
	
func GetWeaponSlots() -> weapon_slots:
	if(weapon_slots == null):
		push_error("Missing ref to weapon slots")
	return weapon_slots
