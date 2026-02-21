extends Area2D

@export var gun_type: Global.Gun_Types

@export var pistol_sprite: Sprite2D
@export var shotgun_sprite: Sprite2D
@export var machine_gun_sprite: Sprite2D
@export var rocket_launcher_sprite: Sprite2D
var gun_sprites := {}

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	gun_type = Global.get_random_gun()
	
	gun_sprites = {
		Global.Gun_Types.PISTOL: pistol_sprite,
		Global.Gun_Types.SHOTGUN: shotgun_sprite,
		Global.Gun_Types.MACHINE_GUN: machine_gun_sprite,
		Global.Gun_Types.ROCKET_LAUNCHER: rocket_launcher_sprite
	}
	
	set_gun_visible(gun_type)
	
func set_gun_visible(gun_type: Global.Gun_Types):
	for sprite in gun_sprites.values():
		sprite.visible = false

	if gun_sprites.has(gun_type):
		gun_sprites[gun_type].visible = true

func _on_body_entered(body: Node) -> void:
	if body is player:
		Global.weapon_slots.add_weapon(gun_type)
		queue_free()
