extends CharacterBody2D


@export var SPEED = 300.0
@export var JUMP_VELOCITY = -600.0
@export var push_force = 80.0
@onready var animation_player: AnimationPlayer = $Sprite2D/AnimationPlayer
const FIRE_BALL = preload("res://scenes/fireBall.tscn")

var last_facing_direction := Vector2(0, 1)
var anim_direction : String

func _ready() -> void:
	animation_player.play("idle_left")

func player():
	pass

func _physics_process(delta: float) -> void:

	current_camera()
	gravity(delta)

	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	
	# Handle jump.
	if Input.is_action_just_pressed("fireball"):
		var fireball = FIRE_BALL.instantiate()
		fireball.set_global_position(global_position)
		fireball.rotation = global_position.direction_to(get_global_mouse_position()).angle()
		owner.add_child(fireball)

	var direction := Input.get_axis("left", "right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	move_and_slide()
	for i in get_slide_collision_count():
		var c = get_slide_collision(i)
		if c.get_collider() is RigidBody2D:
			c.get_collider().apply_central_impulse(-c.get_normal() * push_force)
			
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
