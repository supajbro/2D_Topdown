extends "res://scripts/enemy.gd"

@export var pistol_scene: PackedScene
var pistol_instance: gun = null

func _ready():
	super._ready()
	
	match enemy_type:
		Global.Enemy_Types.SHOOTING:
			pistol_instance = pistol_scene.instantiate()
			pistol_instance.position = global_position
			add_child(pistol_instance)
			
func _attack_state(delta):
	velocity = Vector2.ZERO
	move_and_slide()
	
	match enemy_type:
		Global.Enemy_Types.SHOOTING:
			pistol_instance.shoot(global_position)
			
	super._attack_state(delta)
