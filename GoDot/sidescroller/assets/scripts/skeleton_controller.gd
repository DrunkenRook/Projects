extends CharacterBody2D

@export var speed = 100
@export var gravity = 900
@export var damage = 10

@onready var floor_detector = $FloorDetector
@onready var wall_detector = $WallDetector
@onready var attack_area = $Area2D
@onready var cooldown_timer = $CooldownTimer

#Sets state based on detectors
enum State { patrol, attack, cooldown }
var current_state = State.patrol
var direction = 1


func _physics_process(delta):
	#Apply gravity
	if not is_on_floor():
		velocity.y += gravity * delta
	
	#Handles changing state
	match current_state:
		State.patrol:
			patrol(delta)
		State.attack:
			attack(delta)
		State.cooldown:
			pass
			velocity.x = 0
	
	move_and_slide()

func patrol(_delta):
	velocity.x = speed * direction
	
	#Checks for walls and ledges
	if wall_detector.is_colliding() or not floor_detector.is_colliding():
		#Handles direction
		direction *= -1
		self.scale.x *= -1

#Handles attacks
func attack(_delta):
	velocity.x = 0 #Must stop moving to attack -------------------------- Change depending on enemy
	$AnimationPlayer.play("attack1")

func attack_area_entered(body):
	if body.name == "PlayerBody" and current_state != State.cooldown:
		current_state = State.attack

func attack_area_exited(body):
	if body.name == "PlayerBody":
		current_state = State.cooldown
		cooldown_timer.start()

func cooldown_finished():
	current_state = State.patrol
