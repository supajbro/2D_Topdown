class_name player_camera
extends Camera2D

var player: Node = null

@export var smoothing_speed: float = 5

func init_camera(player_instance: Node):
	player = player_instance
	position_smoothing_enabled = true
	position_smoothing_speed = smoothing_speed
	
	# initial zoom
	zoom = initial_zoom
	zoom_amount = initial_zoom
	
	Global.cam = self

func _physics_process(delta: float) -> void:
	if not player:
		return
		
	camera_movement(delta)

func camera_movement(delta: float):
	global_position = global_position.lerp(player.global_position, position_smoothing_speed * delta)
	
	# Update of camera shake
	update_shake(delta)
	apply_shake_to_camera()
	
	# Update of camera zoom
	update_zoom(delta)
	
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
	
# -------------------------
# ZOOM OUT FUNCTIONS
# -------------------------

var zoom_amount: Vector2
var started_zoom_out: bool = false

@export var zoom_stop_epsilon := 0.01
@export var initial_zoom: Vector2 = Vector2(4, 4)
@export var zoom_decay: float = 5.0
@export var zoom_power_pistol: float = 0.15
@export var zoom_power_machine_gun: float = 0.25
@export var zoom_power_shotgun: float = 0.4

func start_zoom_out(type: Global.Gun_Types) -> void:
	var power := zoom_power_pistol
	match type:
		Global.Gun_Types.MACHINE_GUN:
			power = zoom_power_machine_gun
		Global.Gun_Types.SHOTGUN:
			power = zoom_power_shotgun

	# Zoom out by increasing zoom value
	zoom_amount -= Vector2(power, power)
	
	started_zoom_out = true

func update_zoom(delta: float) -> void:
	if !started_zoom_out:
		return

	zoom_amount = zoom_amount.lerp(
		initial_zoom,
		clamp(zoom_decay * delta, 0.0, 1.0)
	)

	zoom = zoom_amount

	# Stop when close enough
	if zoom_amount.distance_to(initial_zoom) <= zoom_stop_epsilon:
		zoom_amount = initial_zoom
		zoom = initial_zoom
		started_zoom_out = false
