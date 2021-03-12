extends KinematicBody2D

const MAX_SPEED = 90
const ACCELERATION = 400
const FRICTION = 400
const ROLL_SPEED = 130

enum {
	MOVE,
	ROLL,
	ATTACK
	}
	
var state = MOVE
var velocity = Vector2.ZERO
var roll_vector = Vector2.LEFT


onready var animationPlayer = $AnimationPlayer
onready var animationTree = $AnimationTree
onready var animationState = animationTree.get("parameters/playback")
onready var swordHitbox = $HitboxPivot/SwordHitbox

func _ready():
	animationTree.active = true
	swordHitbox.knock_direction = roll_vector

func _physics_process(delta):
	match state: 
		MOVE:
			move_state(delta)
		
		ROLL:
			roll_state(delta)
		
		ATTACK:
			attack_state(delta)
	
func move_state(delta):
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	input_vector = input_vector.normalized()
	#jee
	if Input.is_action_pressed("ui_select"):
		print ("Moi niksu :3")
	if Input.is_action_pressed("ui_jump"):
		print (input_vector)
	#When moving, take direction and create movement. Do animations that match movement
	if input_vector != Vector2.ZERO:
		roll_vector = input_vector
		swordHitbox.knock_direction = input_vector
		animationTree.set("parameters/Idle/blend_position", input_vector)
		animationTree.set("parameters/Run/blend_position", input_vector)
		animationTree.set("parameters/Attack/blend_position", input_vector)
		animationTree.set("parameters/Roll/blend_position", input_vector)
		animationState.travel("Run")
		velocity = velocity.move_toward(input_vector * MAX_SPEED, ACCELERATION * delta)
	#When no imputs for move, slow and show idle animation
	else:
		
		animationState.travel("Idle")
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
	
	#Move character
	move()
	
	if Input.is_action_just_pressed("roll"):
		state = ROLL
	
	if Input.is_action_just_pressed("attack"):
		state = ATTACK
	
#DO ATTACK HERE
func attack_state(delta):
	animationState.travel("Attack")
	velocity = Vector2.ZERO
	
#DO ROLL HERE, take no damage and TODO 1 sec cooldown
func roll_state(delta):
	animationState.travel("Roll")
	velocity = roll_vector * ROLL_SPEED
	
	#Hitbox pois päältä jollain $ käskyllä
	move()

func move():
	velocity = move_and_slide(velocity)

#return to MOVE state
func attack_animation_finished():
	state = MOVE
func roll_animation_finished():
	# SET HURTBOX back on
	velocity = velocity * 0.8
	state = MOVE
