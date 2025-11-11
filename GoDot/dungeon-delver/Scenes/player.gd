extends CharacterBody2D
# Created with the help of GoDot's beginner tutorial
@export var speed = 400
var screen_size

func ready():
	screen_size = get_viewport().size

func _process(delta):
	var velocity = Vector2.ZERO
	if Input.is_action_pressed("moveRight"):
		velocity.x += 1
	if Input.is_action_pressed("moveLeft"):
		velocity.x -= 1
	if Input.is_action_pressed("moveDown"):
		velocity.y += 1
	if Input.is_action_pressed("moveUp"):
		velocity.y -= 1
	
	if velocity.x != 0:
		$PlayerAnimation.animation = "Run"
		$PlayerAnimation.flip_v = false
		$PlayerAnimation.flip_h = velocity.x < 0
	#elif velocity.y != 0:
		#$PlayerAnimation.animation = "Up"
		#$AnimatedSprite2D.flip_v = velocity.y > 0
	else:
		$PlayerAnimation.animation = "Idle"
	
	position += velocity * delta
	position = position.clamp(Vector2.ZERO, screen_size)
