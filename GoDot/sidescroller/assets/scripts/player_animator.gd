extends Node2D

@export var player_controller : PlayerController
@export var animation_player : AnimationPlayer
@export var sprite : Sprite2D

#sprite animation controllers
func _process(delta):
	#flips sprite based on direction
	if player_controller.direction == 1:
		sprite.flip_h = false
	elif player_controller.direction == -1:
		sprite.flip_h = true
	#changes sprite for movement
	if abs(player_controller.velocity.x) > 0:
		animation_player.play("move")
	else:
		animation_player.play("idle")
	#changes sprite for jump or fall
	if player_controller.velocity.y < 0:
		animation_player.play("jump")
	elif player_controller.velocity.y > 0:
		animation_player.play("fall")
	
