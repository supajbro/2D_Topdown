class_name enemy_spawn_point
extends Node2D

# This class is used to determine if we only want to spawn specific enemy types here

@export var spawn_specific_enemy: bool = false
@export var enemy_type: Global.Enemy_Types = Global.Enemy_Types.INVALID_TYPE

func _ready():
	add_to_group("enemy_spawn_point")
