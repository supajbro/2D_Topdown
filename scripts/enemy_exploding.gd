extends "res://scripts/enemy.gd"

@export var explosion_scene: PackedScene
var explosion_instance: explosion = null

func _ready():
	super._ready()
			
func _attack_state(delta):
	velocity = Vector2.ZERO
	move_and_slide()
	
	if(explosion_scene == null):
		push_error("Missing explosion scene. Attack state will not occur")
		return
	
	explosion_instance = explosion_scene.instantiate()
	explosion_instance.position = global_position
	get_tree().current_scene.add_child(explosion_instance)
	
	queue_free()
