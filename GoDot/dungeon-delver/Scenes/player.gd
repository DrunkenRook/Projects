#Player sprite assets aquired from https://penusbmic.itch.io/sci-fi-character-pack-10
# Script written with the help of GoDot's beginner tutorial


extends CharacterBody2D


var speed = 500
var screen_size


func ready():
	screen_size = get_viewport().size
	$PlayerAnimation.play(&"Idle", true)

func _process(delta):
	var velocity = Vector2.ZERO
	if Input.is_action_pressed("moveRight"):
		velocity.x += 20
	if Input.is_action_pressed("moveLeft"):
		velocity.x -= 20
	if Input.is_action_pressed("moveDown"):
		velocity.y += 20
	if Input.is_action_pressed("moveUp"):
		velocity.y -= 20
	if Input.is_action_pressed("attack"):
		$PlayerAnimation.animation = &"Attack"
		#while $PlayerAnimation.animation == &"Attack":
			#velocity.x = 0
			#velocity.y = 0
			
			
	
	if velocity.x != 0 or velocity.y != 0:
		$PlayerAnimation.animation = &"Run"
		$PlayerAnimation.flip_h = velocity.x < 0
	if velocity.x == 0 and velocity.y == 0 and $PlayerAnimation.animation != &"Attack":
		$PlayerAnimation.animation = &"Idle"
	
	position += velocity * delta
	
	
func on_animation_finished() -> void:
	$PlayerAnimation.animation = &"Idle"
	
func on_animation_looped() -> void:
	$PlayerAnimation.animation = &"Idle"
	
func on_attack_entered(area):
	if area.is_in_group("hitbox"):
		area.take_damage()
