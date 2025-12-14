class_name enemy_base
extends CharacterBody2D

@export var speed: float = 100
@export var detection_range: float = 150
@export var attack_range: float = 40

@onready var agent: NavigationAgent2D = $NavigationAgent2D

# Health
var current_health: float
@export var max_health: float = 100

var current_state: String = "idle"
var player_ref: Node2D

@export var enemy_type: Global.Enemy_Types

# random chance to spawn health pickup
@export var health_pickup: PackedScene

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

	#queue_redraw() # Update debug drawing

# -------------------------
# STATE FUNCTIONS
# -------------------------

func _idle_state(delta):
	velocity = Vector2.ZERO
	
	if _distance_to_player() < detection_range:
		_change_state("chase")

	move_and_slide()
	
func _chase_state(delta):
	agent.target_position = player_ref.global_position
	
	var next_point = agent.get_next_path_position()

	var direction = (next_point - global_position).normalized()
	velocity = direction * speed
	move_and_slide()

	var dist = _distance_to_player()
	if dist < attack_range:
		_change_state("attack")
	elif dist > detection_range * 1.5:
		_change_state("idle")

func _attack_state(delta):
	if _distance_to_player() > attack_range:
		_change_state("chase")

# -------------------------
# DEBUG DRAWING
# -------------------------

func _draw():
	var path = agent.get_current_navigation_path()

	if path.size() < 2:
		return

	for i in range(path.size() - 1):
		draw_line(
			path[i] - global_position,
			path[i + 1] - global_position,
			Color.GREEN,
			2
		)

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
	if current_health <= 0:
		return
		
	current_health = max(0, current_health - damage)
	
	if current_health <= 0:
		die()

func die():
	spawn_health_pickup()
	Global.GetEnemySpawner().current_enemies_spawned -= 1
	print(Global.GetEnemySpawner().current_enemies_spawned)
	queue_free()
	
func spawn_health_pickup():
	if Global.rng.randf() < 0.2:
		var pickup = health_pickup.instantiate()
		pickup.global_position = global_position
		get_parent().add_child(pickup)
