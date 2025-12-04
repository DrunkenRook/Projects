extends Area2D
class_name ExitTrigger

@export var sprite : Sprite2D

var is_open = false

func _ready():
	pass

func open():
	is_open = true
	#open Sprite

func close():
	is_open = false
	#close sprite

func exit_entered(body):
	if is_open and body is PlayerController:
		GameManager.next_level()
