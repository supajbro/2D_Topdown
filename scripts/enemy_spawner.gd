class_name enemy_spawner
extends Node

var _enemy_count: int = Global.Enemy_Types.size()
var enemy_list
var spawn_points: Array[enemy_spawn_point]

# choose what enemies we want to spawn (debug feature)
var test_enemy_list: Array
@export var spawn_test_enemies: bool

# Determines how many waves will occur in this scene
@export var max_wave_count: int = 1 # Updated per scene
var current_wave_count: int

# How long it takes for another wave to spawn
@export var max_wave_spawn_delay: float = 1
@export var delay_initial_spawn: bool = false
var current_spawn_delay: float = 0

func _ready():
	Global.enemy_spawner = self
	
	# initialises all spawn points
	for n in get_tree().get_nodes_in_group("enemy_spawn_point"):
		if n is enemy_spawn_point:
			spawn_points.append(n)
	
	current_wave_count = 0
	
	# Initialise the lists of enemies
	enemy_list 			= [enemies_shooting_scene, enemies_exploding_scene]
	test_enemy_list 	= [enemies_shooting_scene]
	
	# spawn first wave of enemies
	if !delay_initial_spawn:
		var _list = test_enemy_list if spawn_test_enemies else enemy_list
		spawn_enemy(_list)

# -------------------------
# UPDATE FUNCTIONS
# -------------------------

func _process(delta: float) -> void:
	spawning_group_enemies_update(delta)

# spawns all enemies again
func spawning_group_enemies_update(delta: float) -> void:
	# don't spawn new enemies if we've hit max wave count
	if(current_wave_count >= max_wave_count):
		return
	
	# when wave is complete, start time to spawn next delay
	if current_enemies_spawned == 0:
		current_spawn_delay += delta
		print(current_spawn_delay)
		
	if current_spawn_delay >= max_wave_spawn_delay:
		current_spawn_delay = 0
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

	for i in range(max_enemies_spawned):
		var spawn_point = spawn_points[i]
		
		# Spawn specific enemy type
		if spawn_point.spawn_specific_enemy == true:
			var enemy = enemies[spawn_point.enemy_type].instantiate()
			enemy.global_position = spawn_point.global_position
			add_child(enemy)
		# Spawn a random enemy type
		else:
			var temp_rand_value: int = Global.rng.randi_range(0, enemies.size() - 1)
			var enemy = enemies[temp_rand_value].instantiate()
			enemy.global_position = spawn_point.global_position
			add_child(enemy)
		current_enemies_spawned += 1
