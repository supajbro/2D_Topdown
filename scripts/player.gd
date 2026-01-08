class_name player
extends CharacterBody2D

@export var speed: float = 50

# Health
var current_health: float
@export var max_health: float = 100

func init():
	add_to_group("player")
	
	# Player health
	current_health = max_health
	health_ui()
	
	pistol_instance = pistol_scene.instantiate()
	pistol_instance.position = global_position
	add_child(pistol_instance)
	
	machine_gun_instance = machine_gun_scene.instantiate()
	machine_gun_instance.position = global_position
	add_child(machine_gun_instance)
	
	shotgun_instance = shotgun_scene.instantiate()
	shotgun_instance.position = global_position
	add_child(shotgun_instance)
	
	selected_weapon = pistol_instance
	
	DebugMenu.register_debug_slider(
	"Player",
	"Move Speed",
	50,
	600,
	speed,
	func(value):
		speed = value
	)

func _on_ready() -> void:
	init()
	
func _physics_process(delta: float) -> void:
	# Control movement
	velocity = Vector2.ZERO
	
	movement(delta)
	velocity = velocity.normalized() * speed
	dash(delta)
	move_and_slide()
	
	# Handle gun controls
	switch_weapon()
	shoot(delta)

# -------------------------
# MOVEMENT
# -------------------------

func movement(delta: float):
	if Input.is_action_pressed("MoveRight"):
		velocity.x += 1
	if Input.is_action_pressed("MoveLeft"):
		velocity.x -= 1
	if Input.is_action_pressed("MoveDown"):
		velocity.y += 1
	if Input.is_action_pressed("MoveUp"):
		velocity.y -= 1

# -------------------------
# DASH
# -------------------------

@export var dash_power: float = 100
var is_dashing: bool = false

var dash_time = 0.25
var dash_timer = 0.0
var dash_direction = Vector2.ZERO

@export var dash_cooldown: float = 1
var current_dash_cooldown: float

func dash(delta: float):
	if current_dash_cooldown < dash_cooldown:
		current_dash_cooldown += delta
	
	if Input.is_action_pressed("Dash") && current_dash_cooldown >= dash_cooldown:
		current_dash_cooldown = 0.0
		
		# we have no current velocity, therefore no dash will happen
		if velocity.length() < 0.1:
			return
			
		is_dashing = true
		dash_timer = dash_time
		dash_direction = velocity.normalized()
		
	if is_dashing:
		dash_timer -= delta
		
		var t = dash_timer / dash_time
		var dash_strength = lerp(dash_power, 0.0, 1.0 - t)
		
		velocity += dash_direction * dash_strength * delta
		
		if dash_timer <= 0.0:
			is_dashing = false

# -------------------------
# WEAPON FUNCTIONS
# -------------------------

@export var pistol_scene: PackedScene
var pistol_instance: gun = null

@export var machine_gun_scene: PackedScene
var machine_gun_instance: gun = null

@export var shotgun_scene: PackedScene
var shotgun_instance: gun = null

# the active weapon the player is using
var selected_weapon: gun = null

func shoot(delta: float):
	if Input.is_action_pressed("Shoot"):
		if selected_weapon:
			selected_weapon.shoot(global_position)
		else:
			push_error("Selected weapon is null")
			
func switch_weapon():
	if Input.is_action_pressed("slot_one"):
		selected_weapon = pistol_instance
	elif Input.is_action_pressed("slot_two"):
		selected_weapon = machine_gun_instance
	elif Input.is_action_pressed("slot_three"):
		selected_weapon = shotgun_instance

# -------------------------
# HEALTH FUNCTIONS
# -------------------------

func damage(damage: float):
	if(current_health <= 0):
		return
	
	current_health = max(0, current_health - damage)
	UI.smoothly_set_screens_slider_value(UI.SCREENS["UI_PLAYER_HEALTH"], current_health)
	
	if(current_health <= 0):
		print("Player is dead")
		
func add_health(value: float):
	if(current_health >= max_health):
		return
	
	current_health = min(max_health, current_health + value)
	UI.smoothly_set_screens_slider_value(UI.SCREENS["UI_PLAYER_HEALTH"], current_health)
		
func health_ui():
	UI.show_screen(UI.SCREENS["UI_PLAYER_HEALTH"])
	UI.set_screens_slider_value(UI.SCREENS["UI_PLAYER_HEALTH"], current_health)
