class_name enemy_base
extends CharacterBody2D

@export var speed: float = 100
@export var detection_range: float = 150
@export var attack_range: float = 40

# Health
var current_health: float
@export var max_health: float = 100

var current_state: String = "idle"
var player_ref: Node2D

@export var enemy_type: Global.Enemy_Types

func _ready():
	add_to_group("enemy")
	player_ref = Global.player
	current_health = max_health
	
func _physics_process(delta):
	match current_state:
		"idle":
			_idle_state(delta)
		"chase":
			_chase_state(delta)
		"attack":
			_attack_state(delta)

# -------------------------
# STATE FUNCTIONS
# -------------------------

func _idle_state(delta):
	velocity = Vector2.ZERO
	
	if _distance_to_player() < detection_range:
		_change_state("chase")

	move_and_slide()
	
func _chase_state(delta):
	var direction = (player_ref.global_position - global_position).normalized()
	velocity = direction * speed
	move_and_slide()
	
	if _distance_to_player() < attack_range:
		_change_state("attack")
	elif _distance_to_player() > detection_range * 1.5:
		_change_state("idle")

func _attack_state(delta):
	# After attacking, either chase again or idle
	if _distance_to_player() > attack_range:
		_change_state("chase")

# -------------------------
# HELPER FUNCTIONS
# -------------------------

func _distance_to_player() -> float:
	if not player_ref:
		return INF
	return global_position.distance_to(player_ref.global_position)

func _change_state(new_state: String):
	if current_state == new_state:
		return
	current_state = new_state
	
# -------------------------
# HEALTH FUNCTIONS
# -------------------------

func damage(damage: float):
	if(current_health <= 0):
		return
		
	current_health = max(0, current_health - damage)
	
	if(current_health <= 0):
		die()

func die():
	Global.GetEnemySpawner().current_enemies_spawned -= 1
	print(Global.GetEnemySpawner().current_enemies_spawned)
	queue_free()
