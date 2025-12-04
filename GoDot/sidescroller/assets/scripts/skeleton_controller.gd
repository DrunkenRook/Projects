extends CharacterBody2D

@export var speed = 60
@export var gravity = 900
@export var health = 2

@onready var floor_detector = $FloorDetector
@onready var wall_detector = $WallDetector
@onready var player_detector = $PlayerDetector
@onready var attack_collisions = $AttackCollisions
@onready var cooldown_timer = $CooldownTimer
@onready var animation_player = $SkeletonAnimator/AnimationPlayer
@onready var skeleton_animator = $SkeletonAnimator

#Sets state based on detectors --------------------------------------Add more states for more attacks?
enum State { patrol, attack, cooldown, dead }
var current_state = State.patrol
var direction = 1



func _physics_process(delta):
	#Handles death
	if current_state == State.dead:
		#if not is_on_floor():
			#velocity.y += gravity * delta
		move_and_slide()
		return
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

func take_damage(amt):
	if current_state == State.dead: 
		return
	else:
		health -= amt
		if health <= 0:
			die()
		else:
			animation_player.play("hit")
			current_state = State.cooldown

func die():
	current_state = State.dead
	velocity.x = 0
	animation_player.play("death")
	$SkeletonBody.set_deferred("disabled", true)
	$AttackCollisions.set_deferred("monitoring", false)
	await animation_player.animation_finished
	queue_free()

func attack_area_entered(body):
	if body is PlayerController and current_state != State.cooldown:
		current_state = State.attack

func attack_area_exited(body):
	if body is PlayerController:
		current_state = State.cooldown
		cooldown_timer.start()

func cooldown_finished():
	current_state = State.patrol

func player_attacked(body):
	print_debug("player attacked")
	if current_state == State.dead:
		return
	if body is PlayerController:
		print_debug("player hit")
		if body.has_method("damage"):
			body.damage(1)
