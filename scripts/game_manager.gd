extends Node

@export var player_scene: PackedScene
var player_instance: Node = null

@export var spawn_pos: Vector2 = Vector2(0, 0)

@export var camera_scene: PackedScene
var camera_instance: player_camera = null

@export var enemy_scene: PackedScene
var enemy_instance: enemy = null

func _ready():
	spawn_player()
	spawn_player_camera()
	spawn_enemy()

func spawn_player():
	if (player_scene):
		# Handle spawning player
		player_instance = player_scene.instantiate()
		player_instance.position = spawn_pos
		add_child(player_instance)
		Global.player = player_instance
	else:
		push_error("No player scene assigned to the game manager")
		
func spawn_player_camera():
	if(player_scene):
		# Handle spawning camera
		print("Spawning camera with player:", player_instance)
		camera_instance = camera_scene.instantiate()
		camera_instance.position = spawn_pos
		camera_instance.init_camera(player_instance)
		add_child(camera_instance)
	else:
		push_error("No camera scene assigned to the game manager")	
		
func spawn_enemy():
	if (enemy_scene):
		# Handle spawning enemy
		enemy_instance = enemy_scene.instantiate()
		enemy_instance.position = Vector2(100, 100)
		add_child(enemy_instance)
	else:
		push_error("No enemy scene assigned to the game manager")
