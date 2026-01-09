class_name bullet
extends Area2D

@export var gun_type: Global.Gun_Types
@export var is_enemy_bullet: bool = false

@export var speed: float = 100
@export var damage: float = 10

var spawned_time: float
@export var lifetime: float = 1
var destroyed: bool = false

var targets_hit: int
@export var max_targets_hit: float = 1

var direction: Vector2 = Vector2.ZERO
	
func _ready():
	if(is_enemy_bullet):
		direction = (Global.player.global_position - global_position).normalized()
	else:
		direction = (get_global_mouse_position() - global_position).normalized()
		Global.GetCamera().add_shake(-direction, gun_type)
		
	connect("body_entered", Callable(self, "_on_body_entered"))

func _process(delta: float) -> void:
	position += direction * speed * delta
	
	# Destroy once bullets lifetime has been hit
	spawned_time += delta
	if (!destroyed && spawned_time > lifetime):
		destroyed = true
		queue_free()
	
func _on_body_entered(body):
	if(is_enemy_bullet):
		if body.is_in_group("player"):
			targets_hit += 1
			print("Hit player")
			if body.has_method("damage"):
				body.damage(damage)
		
		# Destroy bullet after the bullet has hit the max amount of targets
		if (targets_hit >= max_targets_hit):
			queue_free()
		return
		
	
	if body.is_in_group("enemy"):
		targets_hit += 1
		if body.has_method("damage"):
			body.damage(damage)
		
		# Destroy bullet after the bullet has hit the max amount of targets
		if (targets_hit >= max_targets_hit):
			queue_free()
