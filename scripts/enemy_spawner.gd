class_name enemy_spawner
extends Node

var _enemy_count: int = Global.Enemy_Types.size()
var enemy_list
var spawn_points: Array

# choose what enemies we want to spawn (debug feature)
var test_enemy_list: Array
@export var spawn_test_enemies: bool

# Determines how many waves will occur in this scene
@export var max_wave_count: int = 1 # Updated per scene
var current_wave_count: int

func _ready():
	Global.enemy_spawner = self
	
	# initialises all spawn points
	spawn_points = get_tree().get_nodes_in_group("enemy_spawn")
	
	current_wave_count = 0
	
	# Initialise the lists of enemies
	enemy_list 			= [enemies_shooting_scene, enemies_exploding_scene]
	test_enemy_list 	= [enemies_shooting_scene]
	
	# spawn first wave of enemies
	var _list = test_enemy_list if spawn_test_enemies else enemy_list
	spawn_enemy(_list)

# -------------------------
# UPDATE FUNCTIONS
# -------------------------

func _process(delta: float) -> void:
	spawning_group_enemies_update(delta)

# spawns all enemies again
func spawning_group_enemies_update(delta: float) -> void:
	# don't spawn new enemies if there are still enemies or we've hit max wave count
	if(current_enemies_spawned > 0 || current_wave_count >= max_wave_count):
		return
		
	var _list = test_enemy_list if spawn_test_enemies else enemy_list
	spawn_enemy(_list)
		
# -------------------------
# SPAWNING FUNCTIONS
# -------------------------

# TODO: Once we pool enemies, we will grab enemy types from a global class
@export var max_enemies_spawned: int = 10
var current_enemies_spawned: int = 0

@export var enemies_shooting_scene: PackedScene
var enemies_shooting_instances: Array = []

@export var enemies_exploding_scene: PackedScene
var enemies_exploding_instances: Array = []

func spawn_enemy(enemies: Array):
	max_enemies_spawned = spawn_points.size()
	
	if (enemies.size() <= 0):
		return
	if spawn_points.size() < max_enemies_spawned:
		push_error("Not enough spawn points for unique spawns: " + str(spawn_points.size()))
		return
	
	current_wave_count += 1
	print("wave count:", current_wave_count)
	
	# Shuffle the spawn points so every run is random
	var shuffled = spawn_points.duplicate()
	shuffled.shuffle()

	# Spawn only the first N spawn points
	for i in range(max_enemies_spawned):
		var spawn_point = shuffled[i]

		# Spawn a random enemy type
		var temp_rand_value: int = Global.rng.randi_range(0, enemies.size() - 1)
		var enemy = enemies[temp_rand_value].instantiate()
		enemy.global_position = spawn_point.global_position
		add_child(enemy)
		current_enemies_spawned += 1
