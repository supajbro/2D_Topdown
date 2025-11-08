class_name bullet
extends CollisionShape2D

var direction: Vector2 = Vector2.ZERO
@export var speed: float = 100
	
func _ready():
	print("Init bullet")
	direction = (get_global_mouse_position() - global_position).normalized()
	print(direction)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	global_position += direction * speed * delta
