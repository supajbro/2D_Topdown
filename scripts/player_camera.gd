class_name player_camera
extends Camera2D

var player: Node = null

@export var smoothing_speed: float = 5
@export var x_zoom: float = 4
@export var y_zoom: float = 4

func init_camera(player_instance: Node):
	player = player_instance
	position_smoothing_enabled = true
	position_smoothing_speed = smoothing_speed
	zoom.x = x_zoom
	zoom.y = y_zoom

func _physics_process(delta: float) -> void:
	if not player:
		return
		
	camera_movement(delta)

func camera_movement(delta: float):
	global_position = global_position.lerp(player.global_position, position_smoothing_speed * delta)
