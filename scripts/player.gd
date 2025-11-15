class_name player
extends CharacterBody2D

@export var speed: float = 50

@export var pistol_scene: PackedScene
var pistol_instance: gun = null

@export var machine_gun_scene: PackedScene
var machine_gun_instance: gun = null

@export var shotgun_scene: PackedScene
var shotgun_instance: gun = null

# the active weapon the player is using
var selected_weapon: gun = null

# Health
var current_health: float
@export var max_health: float = 100

func _on_ready() -> void:
	add_to_group("player")
	
	current_health = max_health
	
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

func _physics_process(delta: float) -> void:
	# Control movement
	velocity = Vector2.ZERO
	if Input.is_action_pressed("MoveRight"):
		velocity.x += 1
	if Input.is_action_pressed("MoveLeft"):
		velocity.x -= 1
	if Input.is_action_pressed("MoveDown"):
		velocity.y += 1
	if Input.is_action_pressed("MoveUp"):
		velocity.y -= 1

	velocity = velocity.normalized() * speed
	move_and_slide()
	
	# Handle gun controls
	switch_weapon()
	shoot(delta)

# -------------------------
# WEAPON FUNCTIONS
# -------------------------

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
	print(current_health)
	
	Global.GetCamera().apply_shake(Global.GetCamera().mini_shake)
	
	if(current_health <= 0):
		print("Player is dead")
