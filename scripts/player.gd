extends CharacterBody2D

@export var speed: float = 50

@export var bullet_scene: PackedScene
var bullet_instance: bullet = null

var time_since_last_shot: float = 0
@export var fire_rate: float = 0.5

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
	
	shoot(delta)
	
func shoot(delta: float):
	time_since_last_shot += delta
	
	if(time_since_last_shot < fire_rate):
		return
	
	if Input.is_action_pressed("Shoot"):
		time_since_last_shot = 0
		bullet_instance = bullet_scene.instantiate()
		bullet_instance.position = global_position
		get_tree().current_scene.add_child(bullet_instance)
