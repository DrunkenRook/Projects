extends CharacterBody2D
class_name PlayerController

@export var speed = 10
@export var jump_power = 10
@export var animation_player : AnimationPlayer


var speed_multiplier = 30
var jump_multiplier = -30
var direction = 1
var direction_tracker = 1

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _input(event):
	# Handle jump.
	if event.is_action_pressed("jump") and is_on_floor():
		velocity.y = jump_power * jump_multiplier
	#Handle drop
	if event.is_action_pressed("move_down"):
		set_collision_mask_value(10, false)
	else:
		set_collision_mask_value(10, true)

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Get the input direction and handle the movement/deceleration and sprite/collision flips
	if direction != 0:
		direction_tracker = direction
	direction = Input.get_axis("move_left", "move_right")
	if direction != direction_tracker and direction != 0:
		self.scale.x *= -1
	if direction:
		velocity.x = direction * speed * speed_multiplier
	else:
		velocity.x = move_toward(velocity.x, 0, speed * speed_multiplier)
		

	move_and_slide()
