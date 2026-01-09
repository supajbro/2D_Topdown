extends Node

var player: player = null
var cam: player_camera = null
var enemy_spawner: enemy_spawner = null

enum Enemy_Types
{
	SHOOTING = 0,
	EXPLODING,
	INVALID_TYPE
}

enum Gun_Types
{
	PISTOL = 0,
	MACHINE_GUN,
	SHOTGUN,
	ROCKET_LAUNCHER,
	INVALID_TYPE
}

# Global RNG for this script
var rng := RandomNumberGenerator.new()
func _ready():
	rng.seed = randi() % 1000000000  # 0 to 999,999,999
	rng.randomize()
	print(rng.seed)
	
func GetCamera() -> player_camera:
	if(cam == null):
		push_error("Missing ref to camera")
	return cam
	
func GetEnemySpawner() -> enemy_spawner:
	if(enemy_spawner == null):
		push_error("Missing ref to enemy spawner")
	return enemy_spawner
