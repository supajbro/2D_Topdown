extends CharacterBody2D

@export var speed: float = 50

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

	velocity = velocity.normalized() * speed
	move_and_slide()
	
	if Input.is_action_pressed("Shoot"):
		shoot()
	
func shoot():
	print("Shoot")
