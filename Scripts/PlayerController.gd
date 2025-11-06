extends CharacterBody2D


const SPEED = 400.0
const JUMP_VELOCITY = -700.0
const SLIDE_VELOCITY = 4000.0
var PlayerDirection = Vector2.RIGHT
@onready var Coyote_Time = $CoyoteTime
@onready var Dash_Window = $DashWindow

func _physics_process(delta: float) -> void:
	
	
	if Input.is_action_pressed("MoveLeft"):
		PlayerDirection = Vector2.LEFT
	else : if Input.is_action_pressed("MoveRight"):
		PlayerDirection = Vector2.RIGHT
		
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	
		
	
	# jump.
	if Input.is_action_just_pressed("Jump") and (is_on_floor() or not Coyote_Time.is_stopped()):
		velocity.y = JUMP_VELOCITY
	# WallJump
	if not is_on_floor() and is_on_wall() and Input.is_action_pressed("MoveAction"):
		var Wall_Normal = get_wall_normal()
		velocity.y = velocity.y * .001
		if Input.is_action_just_pressed("Jump"):
			velocity.y = JUMP_VELOCITY
			velocity.x = JUMP_VELOCITY * 4 * -Wall_Normal.x
	
	


	# Get the input direction and handle the movement/deceleration..
	var direction := Input.get_axis("MoveLeft", "MoveRight")
	# Slide
	if direction and Input.is_action_just_pressed("MoveAction") and is_on_floor():
		velocity.x = SLIDE_VELOCITY * PlayerDirection.x
		Dash_Window.start()
		
	else: if direction and Dash_Window.is_stopped() and (not is_on_wall_only() or not Input.is_action_pressed("MoveAction")):
			velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		
	var was_on_floor = is_on_floor()
	
	move_and_slide()
	
	if was_on_floor and not is_on_floor():
		Coyote_Time.start()
