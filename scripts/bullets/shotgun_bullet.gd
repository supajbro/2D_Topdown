extends "res://scripts/bullets/bullet.gd"

@export var max_x_offset = 25
@export var max_y_offset = 5

@export var scale_down_speed = 2.0

func _ready():
	var rand_offset = Vector2(Global.rng.randf_range(-max_x_offset, max_x_offset), 
	Global.rng.randf_range(-max_y_offset, max_y_offset))
	
	if(is_enemy_bullet):
		direction = (Global.player.global_position + rand_offset - global_position).normalized()
	else:
		direction = ((get_global_mouse_position() + rand_offset) - global_position).normalized()
		Global.GetCamera().add_shake(-direction, gun_type)
		Global.GetCamera().start_zoom_out(gun_type)
		
	connect("body_entered", Callable(self, "_on_body_entered"))
	
func _process(delta: float) -> void:
	super._process(delta)
	scale = scale.lerp(Vector2.ZERO, delta * scale_down_speed)
