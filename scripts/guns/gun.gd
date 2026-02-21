class_name gun
extends Node

@export var gun_type: Global.Gun_Types
@export var is_enemy_gun: bool = false

@export var bullet_scene: PackedScene
var bullet_instance: bullet = null

var time_since_last_shot: float = 0
@export var fire_rate: float = 0.5

var current_ammo: int  	= 0
var max_ammo: int 		= -1

func _ready():
	current_ammo = max_ammo

func _process(delta: float) -> void:
	time_since_last_shot += delta

func shoot(pos: Vector2):
	if(time_since_last_shot < fire_rate):
		return
		
	time_since_last_shot = 0
	bullet_instance = bullet_scene.instantiate()
	bullet_instance.position = pos
	
	get_tree().current_scene.add_child(bullet_instance)
	
	Global.GetCamera().start_zoom_out(gun_type)
	
	# Decrease ammunition
	current_ammo -= 1
	print("Ammo: ", current_ammo)
