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

func camera_movement(delta: float):
	global_position = global_position.lerp(player.global_position, position_smoothing_speed * delta)
	
	update_shake(delta)
	apply_shake_to_camera()
	
# -------------------------
# SCREEN SHAKE FUNCTIONS
# -------------------------

var shake_amount: Vector2 = Vector2.ZERO
@export var shake_decay: float = 12.0
@export var shake_power_pistol: float = 10.0
@export var shake_power_machine_gun: float = 5.0
@export var shake_power_shotgun: float = 15.0

func add_shake(amount: Vector2, type: Global.Gun_Types) -> void:
	var power = shake_power_pistol
	match(type):
		Global.Gun_Types.MACHINE_GUN:
			power = shake_power_machine_gun
		Global.Gun_Types.SHOTGUN:
			power = shake_power_shotgun
	
	# Add instant shake impulse
	shake_amount += amount * power

func update_shake(delta: float) -> void:
	# Apply velocity to offset
	shake_amount = shake_amount.lerp(Vector2.ZERO, shake_decay * delta)

func apply_shake_to_camera() -> void:
	global_position += shake_amount
