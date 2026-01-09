extends "res://scripts/bullets/bullet.gd"

@export var explosion_scene: PackedScene
var explosion_instance: explosion = null

func _on_body_entered(body):
	if(is_enemy_bullet):
		if body.is_in_group("player"):
			explosion_instance = explosion_scene.instantiate()
			explosion_instance.position = global_position
			get_tree().current_scene.add_child(explosion_instance)
			queue_free()
		return
	
	if body.is_in_group("enemy"):
		explosion_instance = explosion_scene.instantiate()
		explosion_instance.position = global_position
		get_tree().current_scene.add_child(explosion_instance)
		queue_free()
