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
	
	Global.cam = self

func _physics_process(delta: float) -> void:
	if not player:
		return
		
	camera_movement(delta)
	
	camera_shake(delta)

func camera_movement(delta: float):
	global_position = global_position.lerp(player.global_position, position_smoothing_speed * delta)
	
# -------------------------
# SCREEN SHAKE FUNCTIONS
# -------------------------

var shake_amount: float = 0.0
var shake_offset: Vector2 = Vector2.ZERO

@export var shake_frequency: float = 10
@export var shake_decay: float = 5.0
@export var mini_shake: float = 1.25
@export var medium_shake: float = 2.5
@export var large_shake: float = 5.00

func apply_shake(amount: float):
	if shake_amount <= 0.01:
		shake_amount = amount
	
func camera_shake(delta: float):
	if shake_amount > 0.01:
		shake_offset = Vector2(randf_range(-shake_frequency, shake_frequency), randf_range(-shake_frequency, shake_frequency)) * shake_amount
		global_position += shake_offset
		
		shake_amount -= shake_decay * delta
		shake_amount = max(shake_amount, 0)
