extends CharacterBody2D

@export var speed = 60
@export var gravity = 900

@onready var floor_detector = $FloorDetector
@onready var wall_detector = $WallDetector
@onready var player_detector = $PlayerDetector
@onready var attack_collisions = $AttackCollisions
@onready var cooldown_timer = $CooldownTimer
@onready var animation_player = $SkeletonAnimator/AnimationPlayer
@onready var skeleton_animator = $SkeletonAnimator

#Sets state based on detectors --------------------------------------Add more states for more attacks?
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
			cooldown(delta)
			velocity.x = 0
	
	move_and_slide()

func patrol(_delta):
	animation_player.play("move")
	velocity.x = speed * direction
	
	#Checks for walls and ledges
	if is_on_floor():
		if wall_detector.is_colliding() or not floor_detector.is_colliding():
			#Handles direction
			direction *= -1
			skeleton_animator.scale.x = direction 
			wall_detector.scale.x = direction
			floor_detector.position.x = abs(floor_detector.position.x) * direction
			attack_collisions.scale.x = direction
			player_detector.scale.x = direction

#Handles attacks
func attack(_delta):
	velocity.x = 0 #Must stop moving to attack -------------------------- Change depending on enemy
	animation_player.play("attack1")

func cooldown(_delta):
	animation_player.queue("idle")

func attack_area_entered(body):
	if body.is_in_group("PlayerHitbox") and current_state != State.cooldown:
		current_state = State.attack

func attack_area_exited(body):
	if body.is_in_group("PlayerHitbox"):
		current_state = State.cooldown
		cooldown_timer.start()

func cooldown_finished():
	current_state = State.patrol
	
