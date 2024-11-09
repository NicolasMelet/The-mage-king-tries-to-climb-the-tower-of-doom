extends CharacterBody2D


@export var SPEED = 300.0
@export var JUMP_VELOCITY = -600.0
@onready var animation_player: AnimationPlayer = $Sprite2D/AnimationPlayer

var last_facing_direction := Vector2(0, 1)
var anim_direction : String

func _ready() -> void:
	pass
	animation_player.play("idle_left")

func player():
	pass

func _physics_process(delta: float) -> void:

	current_camera()

	# Add the gravity
	if not is_on_floor():
		velocity += get_gravity() * delta

	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	move_and_slide()

func current_camera():
	if global.current_scene == "village":
		$CameraVillage.enabled = true
		$CameraTower.enabled = false
	elif global.current_scene == "tower":
		$CameraVillage.enabled = false
		$CameraTower.enabled = true
