extends CharacterBody2D

const SPEED = 300.0

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

	velocity = velocity.normalized() * SPEED
	move_and_slide()
