class_name enemy_spawner
extends Node

var _enemy_count: int = Global.Enemy_Types.size()
var enemy_list
var enemies_alive: Array[enemy_base]
var spawn_points: Array[enemy_spawn_point]

# choose what enemies we want to spawn (debug feature)
var test_enemy_list: Array
@export var spawn_test_enemies: bool

# Determines how many waves will occur in this scene
@export var max_wave_count: int = 1 # Updated per scene
var current_wave_count: int

# How long it takes for another wave to spawn
const START_WAVE_COMPLETE_UI: 	float = 1
const SPAWN_NEW_WAVE: 			float = 4
@export var delay_initial_spawn: bool = false
var shown_wave_complete_ui: bool = false
var new_wave_timer: float = 0

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
	
	if Input.is_key_pressed(KEY_K):
		debug_kill_all_enemies()

# spawns all enemies again
func spawning_group_enemies_update(delta: float) -> void:
	# when wave is complete, start time to spawn next delay
	if current_enemies_spawned == 0:
		new_wave_timer += delta
		
	if new_wave_timer >= START_WAVE_COMPLETE_UI && !shown_wave_complete_ui && !UI.is_screen_active(UI.SCREENS["UI_WAVE_COMPLETE"]):
		shown_wave_complete_ui = true
		UI.set_screens_text(UI.SCREENS["UI_WAVE_COMPLETE"], "Wave " + 
		str(current_wave_count) + "/" + str(max_wave_count) + 
		" Complete")
		UI.show_screen(UI.SCREENS["UI_WAVE_COMPLETE"])
	elif new_wave_timer >= SPAWN_NEW_WAVE && current_wave_count < max_wave_count:
		new_wave_timer = 0
		shown_wave_complete_ui = false
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

	for i in range(max_enemies_spawned):
		var spawn_point = spawn_points[i]
		
		# Spawn specific enemy type
		if spawn_point.spawn_specific_enemy == true:
			var enemy = enemies[spawn_point.enemy_type].instantiate()
			enemy.global_position = spawn_point.global_position
			add_child(enemy)
			enemies_alive.append(enemy)
		# Spawn a random enemy type
		else:
			var temp_rand_value: int = Global.rng.randi_range(0, enemies.size() - 1)
			var enemy = enemies[temp_rand_value].instantiate()
			enemy.global_position = spawn_point.global_position
			add_child(enemy)
			enemies_alive.append(enemy)
		current_enemies_spawned += 1
		
# -------------------------
# DEBUG FUNCTIONS
# -------------------------

func debug_kill_all_enemies():
	while enemies_alive.size() > 0:
		var enemy = enemies_alive[0]
		enemies_alive.erase(enemy)
		enemy.die()
