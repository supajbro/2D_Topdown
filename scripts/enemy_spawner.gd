extends Node

@export var max_enemies_spawned: int = 10
var current_enemies_spawned: int = 0

@export var enemies_shooting_scene: PackedScene
var enemies_shooting_instances: Array = []

@export var enemies_exploding_scene: PackedScene
var enemies_exploding_instances: Array = []

var _enemy_count: int = Global.Enemy_Types.size()
var enemy_list

var test_enemy_list: Array
@export var spawn_test_enemies: bool

func _ready():
	# Initialise the lists of enemies
	enemy_list 			= [enemies_shooting_scene, enemies_exploding_scene]
	test_enemy_list 	= [enemies_shooting_scene]
	
	var _list = test_enemy_list if spawn_test_enemies else enemy_list
	for i in range(max_enemies_spawned):
		spawn_enemy(_list)

func spawn_enemy(enemies: Array):
	if (enemies.size() <= 0):
		return
	
	# Spawn a random enemy type
	var temp_rand_value: int = Global.rng.randi_range(0, enemies.size() - 1)
	var enemies_shooting_instance = enemies[temp_rand_value].instantiate()
	
	# Choose a random spawn position
	var spawn_points: Array = get_tree().get_nodes_in_group("enemy_spawn")
	var random_spawn = spawn_points[randi() % spawn_points.size()]
	enemies_shooting_instance.position = random_spawn.global_position

	add_child(enemies_shooting_instance)
