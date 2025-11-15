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

func _ready():
	connect("body_entered", Callable(self, "_on_body_entered"))

func _process(delta: float) -> void:
	scale = scale.lerp(target_scale, delta * scale_speed)
	
	# Destroy once bullets lifetime has been hit
	spawned_time += delta
	if (!destroyed && spawned_time > lifetime):
		destroyed = true
		queue_free()
	
func _on_body_entered(body):
	if(is_enemy_explosion):
		if body.is_in_group("player"):
			targets_hit += 1
			print("Hit player")
			if body.has_method("damage"):
				body.damage(damage)

		return
		
	
	if body.is_in_group("enemy"):
		targets_hit += 1
		if body.has_method("damage"):
			body.damage(damage)
