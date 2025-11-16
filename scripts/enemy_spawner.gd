class_name enemy_spawner
extends Node

@export var max_enemies_spawned: int = 10
var current_enemies_spawned: int = 0

@export var enemies_shooting_scene: PackedScene
var enemies_shooting_instances: Array = []

@export var enemies_exploding_scene: PackedScene
var enemies_exploding_instances: Array = []

var _enemy_count: int = Global.Enemy_Types.size()
var enemy_list

var spawn_points: Array

@export var min_spawn_delay: float = 5
@export var max_spawn_delay: float = 10
var spawn_delay = 0
var current_spawn_delay = 0

var test_enemy_list: Array
@export var spawn_test_enemies: bool

func _ready():
	Global.enemy_spawner = self
	
	spawn_points = get_tree().get_nodes_in_group("enemy_spawn")
	
	# Initialise the lists of enemies
	enemy_list 			= [enemies_shooting_scene, enemies_exploding_scene]
	test_enemy_list 	= [enemies_shooting_scene]
	
	var _list = test_enemy_list if spawn_test_enemies else enemy_list
	spawn_enemy(_list)

# -------------------------
# UPDATE FUNCTIONS
# -------------------------

func _process(delta: float) -> void:
	#spawning_individual_enemies_update(delta)
	spawning_group_enemies_update(delta)

# spawns enemies over a set time when there is less than max enemies
func spawning_individual_enemies_update(delta: float) -> void:
	if(current_enemies_spawned >= max_enemies_spawned):
		return
	current_spawn_delay += delta
	var _list = test_enemy_list if spawn_test_enemies else enemy_list
	if(current_spawn_delay >= spawn_delay):
		spawn_individual_enemy(_list)

# spawns all enemies again
func spawning_group_enemies_update(delta: float) -> void:
	if(current_enemies_spawned > 0):
		return
	var _list = test_enemy_list if spawn_test_enemies else enemy_list
	spawn_enemy(_list)
		
# -------------------------
# SPAWNING FUNCTIONS
# -------------------------

func spawn_enemy(enemies: Array):
	max_enemies_spawned = spawn_points.size()
	
	if (enemies.size() <= 0):
		return
	if spawn_points.size() < max_enemies_spawned:
		push_error("Not enough spawn points for unique spawns: " + str(spawn_points.size()))
		return
	
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
		
func spawn_individual_enemy(enemies: Array):
		# Spawn a random enemy type
		var temp_rand_value: int = Global.rng.randi_range(0, enemies.size() - 1)
		var enemy = enemies[temp_rand_value].instantiate()
		
		# Choose a random spawn position
		var spawn_points: Array = get_tree().get_nodes_in_group("enemy_spawn")
		var random_spawn = spawn_points[Global.rng.randi() % spawn_points.size()]
		enemy.position = random_spawn.global_position
		
		add_child(enemy)
		current_enemies_spawned += 1
		
		spawn_delay = Global.rng.randf_range(min_spawn_delay, max_spawn_delay)
		current_spawn_delay = 0
