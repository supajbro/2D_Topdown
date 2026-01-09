extends "res://scripts/guns/gun.gd"

var bullet_instance_2: bullet = null
var bullet_instance_3: bullet = null

@onready var spawn_left = $Spawn_Left
@onready var spawn_middle = $Spawn_Middle
@onready var spawn_right = $Spawn_Right

func shoot(pos: Vector2):
	if(time_since_last_shot < fire_rate):
		return
	time_since_last_shot = 0
	
	var spawns = [spawn_left, spawn_middle, spawn_right]
	for spawn in spawns:
		var bullet = bullet_scene.instantiate()
		bullet.global_position = spawn.global_position
		get_tree().current_scene.add_child(bullet)
		print("Happened")
	Global.GetCamera().start_zoom_out(gun_type)
