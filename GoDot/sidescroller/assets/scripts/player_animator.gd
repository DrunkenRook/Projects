extends Node2D

@export var player_controller : PlayerController
@export var animation_player : AnimationPlayer
@export var sprite : Sprite2D

var second_attack = false
var third_attack = false
var hearts_list : Array[TextureRect]
var health = 3

func _ready() -> void:
	for child in $HealthBar/HBoxContainer.get_children():
		hearts_list.append(child)
	print(hearts_list)

func _input(event):
	#Handles attacks
	if event.is_action_pressed("attack"):
		if animation_player.current_animation == "attack1":
			second_attack = true
		elif animation_player.current_animation == "attack2":
			third_attack = true
		else:
			animation_player.play("attack1")

#sprite animation controllers
func _process(_delta):
	
	#changes sprite for movement
	if abs(player_controller.velocity.x) > 0:
		animation_player.play("move")
	elif player_controller.velocity.x == 0 and animation_player.current_animation == "move":
		animation_player.play("idle")
	#changes sprite for jump or fall
	if player_controller.velocity.y < 0:
		animation_player.play("jump")
	elif player_controller.velocity.y > 0:
		animation_player.play("fall")
	
func _on_animation_player_animation_finished(anim: StringName) -> void:
	if anim == "attack1" and second_attack == true:
		animation_player.play("attack2")
		second_attack = false
	elif anim == "attack2" and third_attack == true:
		animation_player.play("attack3")
		third_attack = false
	else:
		animation_player.play("idle")
		second_attack = false
		third_attack = false

func update_hearts():
	for i in range(hearts_list.size()):
		hearts_list[i].visible = i < health

func health_change(temp):
	health = temp
	update_hearts()
