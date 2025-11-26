extends CharacterBody2D
class_name PlayerController

@export var speed = 10
@export var jump_power = 10
@export var animation_player : AnimationPlayer


var speed_multiplier = 30
var jump_multiplier = -30
var direction = 0


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
	#flip collisions
	if event.is_action_pressed("move_right") or event.is_action_pressed("move_left"):
		self.scale.x = -1
		print_debug(self.scale.x)

func _physics_process(delta: float) -> void:
	# Add the gravity.
	print_debug("process scale: " + str(self.scale.x))
	if velocity.x == 0 and velocity.y == 0:
		self.scale.x = -1
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Get the input direction and handle the movement/deceleration.
	direction = Input.get_axis("move_left", "move_right")
	if direction:
		velocity.x = direction * speed * speed_multiplier
	else:
		velocity.x = move_toward(velocity.x, 0, speed * speed_multiplier)
		

	move_and_slide()
