extends CharacterBody2D

@export var speed: float = 150.0  # Movement speed
@export var jump_force: float = 200.0  # Jump strength
@export var gravity: float = 500.0  # Gravity force
@export var friction: float = 500.0  # Custom friction value
@export var air_friction: float = 150.0

@onready var character_sprite = get_node("CharacterSprite")


func current_animation(animation):
	if character_sprite.animation == animation:
		return true
	else:
		return false


func _physics_process(delta):
	# Apply gravity
	if not is_on_floor():
		velocity.y += gravity * delta

	# Movement input
	var direction = Input.get_axis("move_left", "move_right")
	
	if direction != 0:
		velocity.x = direction * speed
		character_sprite.scale.x = -1 if direction < 0 else 1
		character_sprite.play("moving")
	else:
		# Apply friction only when no movement input is given
		if is_on_floor():
			velocity.x = move_toward(velocity.x, 0, friction * delta)
		else:
			velocity.x = move_toward(velocity.x, 0, air_friction * delta)

		# Play idle animation when not moving
		if is_on_floor():
			character_sprite.play("idle")

	# Jump input
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = -jump_force
		if direction == 0:
			character_sprite.play("jump_start")  # Play jump start animation

	# Transition to jump_end when falling
	if velocity.y > 0 and not is_on_floor():
		if !current_animation("jump_end"):
			character_sprite.play("jump_end")

	# Apply movement
	move_and_slide()
