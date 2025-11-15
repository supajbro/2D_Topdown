extends Node

@export var max_enemies_spawned: int = 10
var current_enemies_spawned: int = 0

@export var enemies_shooting_scene: PackedScene
var enemies_shooting_instances: Array = []

@export var enemies_exploding_scene: PackedScene
var enemies_exploding_instances: Array = []

var _enemy_count: int = Global.Enemy_Types.size()
var enemy_list

func _ready():
	enemy_list = [enemies_shooting_scene, enemies_exploding_scene]
	for i in range(max_enemies_spawned):
		spawn_enemy()


func spawn_enemy():
	if (enemy_list.size() <= 0):
		return
	
	# Spawn a random enemy type
	var rng := RandomNumberGenerator.new()
	rng.randomize()
	var temp_rand_value: int = rng.randi_range(0, enemy_list.size() - 1)
	var enemies_shooting_instance = enemy_list[temp_rand_value].instantiate()
	
	# Choose a random spawn position
	var spawn_points: Array = get_tree().get_nodes_in_group("enemy_spawn")
	var random_spawn = spawn_points[randi() % spawn_points.size()]
	enemies_shooting_instance.position = random_spawn.global_position

	add_child(enemies_shooting_instance)
