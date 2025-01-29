extends CharacterBody2D

@export var speed: float = 150.0  # Movement speed
@export var jump_force: float = 200.0  # Jump strength
@export var gravity: float = 500.0  # Gravity force
@export var friction: float = 500.0  # Custom friction value
@export var air_friction: float = 150.0

func _physics_process(delta):
	# Apply gravity
	if not is_on_floor():
		velocity.y += gravity * delta

	# Movement input
	var direction = Input.get_axis("move_left", "move_right")
	if direction:
		velocity.x = direction * speed
		
	if is_on_floor():
		# Apply custom friction by reducing velocity.x gradually when on the ground
		velocity.x = move_toward(velocity.x, 0, friction * delta)
	else:
		# Apply custom friction by reducing velocity.x gradually when in the air
		velocity.x = move_toward(velocity.x, 0, air_friction * delta)

	# Jump input
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = -jump_force

	# Apply movement
	move_and_slide()