extends Area2D

const HEALTH = 25

func _ready() -> void:
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node) -> void:
	if body is player:
		body.add_health(HEALTH)
		queue_free()
