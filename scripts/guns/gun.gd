class_name gun
extends Node2D
	
@export var gun_type: 			Global.Gun_Types
@export var is_enemy_gun: 		bool 				= false

@export var bullet_scene: 		PackedScene
var bullet_instance: 			bullet 				= null

var time_since_last_shot: 		float 				= 0
@export var fire_rate: 			float 				= 0.5

@export var gun_distance: 		float 				= 25.0
@export var gun_sprite: 		Sprite2D
@export var shoot_position: 	Node2D

var current_ammo: 				int  				= 0
@export var max_ammo: 			int 				= -1

func _ready():
	current_ammo = max_ammo
	set_sprite_visibility(false)

func _process(delta: float) -> void:
	time_since_last_shot += delta
	
	if gun_sprite != null:
		debug_ray = get_gun_ray(ray_length)
		queue_redraw()
		
	follow_mouse()

func shoot(pos: Vector2):
	if(time_since_last_shot < fire_rate):
		return
	
	if current_ammo <= 0:
		return
	
	time_since_last_shot = 0
	bullet_instance = bullet_scene.instantiate() as bullet
	
	var shoot_pos = shoot_position.global_position if shoot_position != null else global_position
	bullet_instance.position = shoot_pos
	
	if !is_enemy_gun:
		bullet_instance.player_bullet_init(get_gun_direction())
	
	get_tree().current_scene.add_child(bullet_instance)
	
	Global.GetCamera().start_zoom_out(gun_type)
	
	# Decrease ammunition
	current_ammo -= 1
	
func get_gun_direction() -> Vector2:
	if gun_sprite == null:
		return Vector2.ZERO
	return Vector2.RIGHT.rotated(gun_sprite.rotation).normalized()
	
func get_gun_ray(length: float = 100.0):
	if gun_sprite == null:
		return Vector2.ZERO
	var origin = gun_sprite.global_position
	var dir = Vector2.RIGHT.rotated(gun_sprite.rotation).normalized()
	var end	= origin + dir * length
	return [origin, end]
	
var debug_ray := []
var ray_length := 100.0

func _draw():
	if debug_ray.size() == 2:
		draw_line(
			to_local(debug_ray[0]),
			to_local(debug_ray[1]),
			Color.RED,
			2.0
		)
	
# The gun sprite will follow the mouse around a circle around the player
func follow_mouse():
	if gun_sprite == null:
		return
		
	if Global.GetPlayer() == null:
		return
	
	var mouse_pos = get_global_mouse_position()

	# Direction from player to mouse
	var direction = (mouse_pos - Global.GetPlayer().global_position).normalized()

	# Position gun in a circle around the player
	gun_sprite.global_position = Global.GetPlayer().global_position + direction * gun_distance

	# Rotate gun to face mouse
	gun_sprite.rotation = direction.angle()

func set_sprite_visibility(bVisible: bool):
	if gun_sprite == null:
		return
	gun_sprite.visible = bVisible
