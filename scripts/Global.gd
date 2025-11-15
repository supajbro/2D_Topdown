extends Node

var player: player = null

enum Enemy_Types
{
	SHOOTING = 0,
	EXPLODING,
	INVALID_TYPE
}

# Global RNG for this script
var rng := RandomNumberGenerator.new()

func _ready():
	rng.seed = randi() % 1000000000  # 0 to 999,999,999
	rng.randomize()
	print(rng.seed)
