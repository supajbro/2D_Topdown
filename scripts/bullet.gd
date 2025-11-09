class_name bullet
extends Area2D

var direction: Vector2 = Vector2.ZERO
@export var speed: float = 100
@export var damage: float = 10

var spawned_time: float
@export var lifetime: float = 1
var destroyed: bool = false

var targets_hit: int
@export var max_targets_hit: float = 1
	
func _ready():
	direction = (get_global_mouse_position() - global_position).normalized()
	connect("body_entered", Callable(self, "_on_body_entered"))

func _process(delta: float) -> void:
	position += direction * speed * delta
	
	# Destroy once bullets lifetime has been hit
	spawned_time += delta
	if (!destroyed && spawned_time > lifetime):
		destroyed = true
		queue_free()
	
func _on_body_entered(body):
	if body.is_in_group("enemy"):
		targets_hit += 1
		if body.has_method("damage"):
			body.damage(damage)
		
		# Destroy bullet after the bullet has hit the max amount of targets
		if (targets_hit >= max_targets_hit):
			queue_free()
