class_name gun
extends Node2D

@export var gun_type: Global.Gun_Types
@export var is_enemy_gun: bool = false

@export var bullet_scene: PackedScene
var bullet_instance: bullet = null

var time_since_last_shot: float = 0
@export var fire_rate: float = 0.5

@export var gun_distance: float = 25.0
@export var gun_sprite: Sprite2D
@export var shoot_position: Node2D

var current_ammo: int  	= 0
var max_ammo: int 		= -1

func _ready():
	current_ammo = max_ammo
	set_sprite_visibility(false)

func _process(delta: float) -> void:
	time_since_last_shot += delta
	follow_mouse()

func shoot(pos: Vector2):
	if(time_since_last_shot < fire_rate):
		return
		
	time_since_last_shot = 0
	bullet_instance = bullet_scene.instantiate()
	
	var shoot_pos = shoot_position.global_position if shoot_position != null else global_position
	bullet_instance.position = shoot_pos
	
	get_tree().current_scene.add_child(bullet_instance)
	
	Global.GetCamera().start_zoom_out(gun_type)
	
	# Decrease ammunition
	current_ammo -= 1
	print("Ammo: ", current_ammo)
	
# The gun sprite will follow the mouse around a circle around the player
func follow_mouse():
	if gun_sprite == null:
		return
	
	var mouse_pos = get_global_mouse_position()

	# Direction from player to mouse
	var direction = (mouse_pos - Global.GetPlayer().global_position).normalized()

	# Position gun in a circle around the player
	gun_sprite.global_position = Global.GetPlayer().global_position + direction * gun_distance

	# Rotate gun to face mouse
	gun_sprite.rotation = direction.angle()
	
	if direction.x < 0:
		gun_sprite.flip_v = true
	else:
		gun_sprite.flip_v = false

func set_sprite_visibility(bVisible: bool):
	if gun_sprite == null:
		return
	gun_sprite.visible = bVisible
