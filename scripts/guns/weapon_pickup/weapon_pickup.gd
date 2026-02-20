extends Area2D

@export var gun_type: Global.Gun_Types

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	gun_type = Global.get_random_gun()

func _on_body_entered(body: Node) -> void:
	if body is player:
		Global.weapon_slots.add_weapon(gun_type)
		queue_free()
