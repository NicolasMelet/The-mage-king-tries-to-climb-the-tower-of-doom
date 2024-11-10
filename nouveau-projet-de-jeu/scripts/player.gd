extends CharacterBody2D


@export var SPEED = 100.0
@export var JUMP_VELOCITY = -300.0
@export var push_force = 80.0
@onready var animation_player: AnimationPlayer = $Sprite2D/AnimationPlayer
const FIRE_BALL = preload("res://scenes/fireBall.tscn")
@onready var AIR_FRICTION = 5
var energyExplosion = 0

var last_facing_direction := Vector2(0, 1)
var anim_direction : String
var countTimeCharge = 0
@export var MAX_CHARGE = 0.7
@export var MID_CHARGE = 0.2

func _ready() -> void:
	animation_player.play("idle_left")

func player():
	pass

func explosion(energy):
	energyExplosion = energy

func _physics_process(delta: float) -> void:

	current_camera()
	gravity(delta)

	#if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		#velocity.y = JUMP_VELOCITY
	
	# Handle jump.
	if Input.is_action_pressed("fireball"):
		countTimeCharge += delta

	if countTimeCharge > 0 and (Input.is_action_just_released("fireball") or countTimeCharge >= MAX_CHARGE):
		var fireball = FIRE_BALL.instantiate()
		if countTimeCharge >= MAX_CHARGE:
			fireball.setSize(2)
		elif countTimeCharge >= MID_CHARGE:
			fireball.setSize(1)
		else:
			fireball.setSize(0)
		countTimeCharge = 0
		var futur_pos = global_position
		futur_pos.x += 8
		fireball.set_global_position(futur_pos)
		fireball.rotation = global_position.direction_to(get_global_mouse_position()).angle()
		fireball.global_position += global_position.direction_to(get_global_mouse_position()) * 50
		owner.add_child(fireball)

	var direction := Input.get_axis("left", "right") if not is_on_floor() else 0.0
	if direction:
		velocity.x = direction * SPEED + energyExplosion
	elif velocity.x != 0:
		velocity.x = move_toward(velocity.x, 0, AIR_FRICTION)
	
	energyExplosion = move_toward(energyExplosion, 0, AIR_FRICTION)
	
	
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
