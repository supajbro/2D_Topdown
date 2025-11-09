class_name bullet
extends Area2D

var direction: Vector2 = Vector2.ZERO
@export var speed: float = 100
	
func _ready():
	direction = (get_global_mouse_position() - global_position).normalized()
	connect("body_entered", Callable(self, "_on_body_entered"))

func _process(delta: float) -> void:
	position += direction * speed * delta
	
func _on_body_entered(body):
	if body.is_in_group("enemy"):
		print("Hit enemy")
		if body.has_method("damage"):
			body.damage(10)
		queue_free() # destroy bullet after hitting enemy
