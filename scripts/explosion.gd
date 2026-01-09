class_name explosion
extends Area2D

@export var is_enemy_explosion: bool = false

# Unit scales per second
@export var scale_speed := 2.0
@export var target_scale := Vector2.ONE * 5

@export var damage: float = 10

var spawned_time: float
@export var lifetime: float = 1
var destroyed: bool = false

var targets_hit: int
@export var max_targets_hit: float = 1

var bodies_in_explosion: Array[Node] = []
@export var tick_damage := 10
@export var tick_rate := 0.1
var damage_timer: Timer

func _ready():
	connect("body_entered", Callable(self, "_on_body_entered"))
	var timer := Timer.new()
	timer.wait_time = tick_rate
	timer.one_shot = false
	timer.autostart = false
	timer.timeout.connect(_on_damage_tick)
	add_child(timer)
	damage_timer = timer

func _process(delta: float) -> void:
	scale = scale.lerp(target_scale, delta * scale_speed)
	
	# Destroy once bullets lifetime has been hit
	spawned_time += delta
	if (!destroyed && spawned_time > lifetime):
		destroyed = true
		queue_free()
	
func _on_body_entered(body):
	var name: String = "player" if is_enemy_explosion else "enemy"
	if body.is_in_group(name) and body.has_method("damage"):
		if body not in bodies_in_explosion:
			bodies_in_explosion.append(body)

			if bodies_in_explosion.size() == 1:
				damage_timer.start()
				
func _on_body_exited(body):
	if body in bodies_in_explosion:
		bodies_in_explosion.erase(body)

		if bodies_in_explosion.is_empty():
			damage_timer.stop()
			
func _on_damage_tick():
	for body in bodies_in_explosion:
		if is_instance_valid(body):
			body.damage(tick_damage)
