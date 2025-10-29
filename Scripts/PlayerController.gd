extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -600.0
var PlayerDirection = Vector2.RIGHT
@onready var  Coyote_Time = $CoyoteTime

func _physics_process(delta: float) -> void:
	
	
	if Input.is_action_just_pressed("MoveLeft"):
		PlayerDirection = Vector2.LEFT
	else : if Input.is_action_just_pressed("MoveRight"):
		PlayerDirection = Vector2.RIGHT
		
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	
	# Handle jump.
	if Input.is_action_just_pressed("Jump") and (is_on_floor() or not Coyote_Time.is_stopped()):
		velocity.y = JUMP_VELOCITY
		
	if not is_on_floor() and is_on_wall() and Input.is_action_pressed("HugWall"):
		velocity.y = velocity.y * .001
		if PlayerDirection == Vector2.LEFT and Input.is_action_just_pressed("Jump"):
			velocity.y = JUMP_VELOCITY
			velocity.x = -JUMP_VELOCITY * 4
		else: if PlayerDirection == Vector2.RIGHT and Input.is_action_pressed("Jump"):
			velocity.y = JUMP_VELOCITY
			velocity.x = JUMP_VELOCITY * 4
	
	


	# Get the input direction and handle the movement/deceleration..
	var direction := Input.get_axis("MoveLeft", "MoveRight")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		
	var was_on_floor = is_on_floor()
	
	move_and_slide()
	
	if was_on_floor and not is_on_floor():
		Coyote_Time.start()
