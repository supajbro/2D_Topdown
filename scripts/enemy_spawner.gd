extends Node

@export var max_enemies_spawned: int = 10
var current_enemies_spawned: int = 0

@export var enemies_shooting_scene: PackedScene
var enemies_shooting_instances: Array = []

func _ready():
	for i in range(max_enemies_spawned):
		spawn_enemy()

func spawn_enemy():
	if (enemies_shooting_scene):
		var enemies_shooting_instance = enemies_shooting_scene.instantiate()
		
		# Choose a random spawn position
		var spawn_points: Array = get_tree().get_nodes_in_group("enemy_spawn")
		var random_spawn = spawn_points[randi() % spawn_points.size()]
		enemies_shooting_instance.position = random_spawn.global_position

		add_child(enemies_shooting_instance)
	else:
		push_error("No enemy scene assigned to the game manager")
