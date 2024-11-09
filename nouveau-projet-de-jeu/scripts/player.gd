extends CharacterBody2D


@export var SPEED = 300.0
@export var JUMP_VELOCITY = -600.0
const FIRE_BALL = preload("res://scenes/fireBall.tscn")

func player():
	pass

func _physics_process(delta: float) -> void:
	current_camera()
	gravity(delta)
	
	# Handle jump.
	if Input.is_action_just_pressed("fireball"):
		var fireball = FIRE_BALL.instantiate()
		fireball.set_global_position(global_position)
		fireball.rotation = global_position.direction_to(get_global_mouse_position()).angle()
		owner.add_child(fireball)

	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		
	#if Input.is_mouse_button_pressed(1): # when click Left mouse button
		#target = get_global_mouse_position()
	#velocity = global_position.direction_to(target) * speed
	#if global_position.distance_to(target) > 5:
		#velocity = move_and_slide(velocity)

	move_and_slide()
	
func gravity(delta):
	if not is_on_floor():
		velocity += get_gravity() * delta

func current_camera():
	if global.current_scene == "village":
		$CameraVillage.enabled = true
		$CameraTower.enabled = false
	elif global.current_scene == "tower":
		$CameraVillage.enabled = false
		$CameraTower.enabled = true
		
