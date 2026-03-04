class_name weapon_pickup
extends Area2D

@export var gun_type: Global.Gun_Types = Global.Gun_Types.INVALID_TYPE
var ammo: int = 0

@export var pistol_sprite: Sprite2D
@export var shotgun_sprite: Sprite2D
@export var machine_gun_sprite: Sprite2D
@export var rocket_launcher_sprite: Sprite2D
var gun_sprites := {}

var lifetime: 					float = 0
@export var max_collect_timer: 	float = 2
@export var max_lifetime: 		float = 10

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	
func _process(delta: float) -> void:
	lifetime += delta
	
	# Remove weapon pickup after max lifetime is reached.
	if lifetime >= max_lifetime:
		queue_free()

func init_gun_sprites():
	gun_sprites = {
		Global.Gun_Types.PISTOL: pistol_sprite,
		Global.Gun_Types.SHOTGUN: shotgun_sprite,
		Global.Gun_Types.MACHINE_GUN: machine_gun_sprite,
		Global.Gun_Types.ROCKET_LAUNCHER: rocket_launcher_sprite
	}

# Regular init func when weapon is added to the scene.
func init():
	gun_type = Global.get_random_gun()
	init_gun_sprites()
	set_gun_visible(gun_type)
	var weapon_found = Global.GetPlayer().weapon_map.get(gun_type)
	set_initial_ammo(weapon_found.max_ammo)
	
# Init func for when player drops weapon.
func init_drop_weapon(type: Global.Gun_Types, drop_ammo_amount: int):
	gun_type = type
	init_gun_sprites()
	set_gun_visible(gun_type)
	set_initial_ammo(drop_ammo_amount)
	
func set_initial_ammo(initial_ammo: int):
	ammo = initial_ammo
	
func set_gun_visible(gun_type: Global.Gun_Types):
	for sprite in gun_sprites.values():
		sprite.visible = false

	if gun_sprites.has(gun_type):
		gun_sprites[gun_type].visible = true

func _on_body_entered(body: Node) -> void:
	if body is player && lifetime > max_collect_timer:
		Global.weapon_slots.add_weapon(gun_type, ammo)
		queue_free()
