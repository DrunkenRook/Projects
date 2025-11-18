#Player sprite assets aquired from https://penusbmic.itch.io/sci-fi-character-pack-10
# Script written with the help of GoDot's beginner tutorial


extends CharacterBody2D

var speed = 500
var screen_size

func ready():
	screen_size = get_viewport().size
	$PlayerAnimation.animation = (&"Idle")
	$PlayerAnimation.play()

func process(delta):
	var velocity = Vector2.ZERO
	if Input.is_action_pressed(&"moveRight"):
		velocity.x += 10
	if Input.is_action_pressed(&"moveLeft"):
		velocity.x -= 10
	if Input.is_action_pressed(&"moveDown"):
		velocity.y += 10
	if Input.is_action_pressed(&"moveUp"):
		velocity.y -= 10
	
	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
	
	position += velocity * delta
	#position = position.clamp(Vector2.ZERO, screen_size)
	
	if velocity.x != 0:
		$PlayerAnimation.animation = &"Run"
		$PlayerAnimation.flip_h = velocity.x < 0
	else:
		$PlayerAnimation.animation = &"Idle"
	
	


	
