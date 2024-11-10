extends CharacterBody2D

@export var SPEED = 100.0
@export var JUMP_VELOCITY = -300.0
@export var push_force = 80.0
@export var MAX_CHARGE = 0.7
@export var MID_CHARGE = 0.2
@export var HOOK_SPEED = 800.0
@export var MAX_HOOK_DISTANCE = 600.0
@export var SWING_FORCE = 40.0
@export var MAX_HOOKS = 2

@onready var animation_player: AnimationPlayer = $Sprite2D/AnimationPlayer
@onready var hook_point = $HookPoint
@onready var hook_ray = $HookRay
@onready var rope_line = $RopeLine

const FIRE_BALL = preload("res://scenes/fireBall.tscn")
@onready var AIR_FRICTION = 5

var energyExplosion = 0
var last_facing_direction := Vector2(0, 1)
var anim_direction : String
var countTimeCharge = 0

var left_hook = MAX_HOOKS
var hook_state = "idle"
var hook_target = Vector2.ZERO
var hook_velocity = Vector2.ZERO
var rope_length = 0.0

func _ready() -> void:
	animation_player.play("idle_left")

func _physics_process(delta: float) -> void:
	current_camera()

	if hook_state != "hooked":
		gravity(delta)
	

	handle_fireball(delta)
	

	match hook_state:
		"idle":
			handle_idle_state()
		"hooked":
			handle_hooked_state(delta)

	handle_movement()
	
	move_and_slide()
	update_rope_visual()

	for i in get_slide_collision_count():
		var c = get_slide_collision(i)
		if c.get_collider() is RigidBody2D:
			c.get_collider().apply_central_impulse(-c.get_normal() * push_force)

func handle_fireball(delta: float) -> void:
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

func handle_movement() -> void:
	var direction := Input.get_axis("left", "right") if not is_on_floor() else 0.0
	if direction:
		velocity.x = direction * SPEED + energyExplosion
	elif velocity.x != 0 && hook_state == "idle":
		velocity.x = move_toward(velocity.x, 0, AIR_FRICTION)
	
	energyExplosion = move_toward(energyExplosion, 0, AIR_FRICTION)

func handle_idle_state() -> void:
	if left_hook > 0:
		if Input.is_action_just_pressed("shoot_hook"):
			var mouse_pos = get_global_mouse_position()
			
			var direction = (mouse_pos - global_position).normalized()
			hook_ray.target_position = direction * MAX_HOOK_DISTANCE
			hook_ray.force_raycast_update()
			
			if hook_ray.is_colliding():
				hook_target = hook_ray.get_collision_point()
				hook_point.global_position = hook_target
				hook_state = "hooked"
				hook_point.visible = true
				left_hook -= 1
				rope_length = global_position.distance_to(hook_target)
	elif is_on_floor():
		left_hook = MAX_HOOKS

func handle_hooked_state(delta: float) -> void:
	hook_point.global_position = hook_target
	
	var to_hook = hook_target - global_position
	var current_length = to_hook.length()
	
	velocity.y += get_gravity().y * delta
	
	var angle_from_vertical = abs(Vector2.DOWN.angle_to(to_hook))

	if current_length > rope_length:
		var correction = to_hook.normalized() * (current_length - rope_length)
		global_position += correction

		to_hook = hook_target - global_position
		current_length = to_hook.length()
		
		var rope_force = to_hook.normalized() * (current_length - rope_length) * 30.0
		var angle_factor = cos(angle_from_vertical)
		rope_force *= max(angle_factor, 0.1)
		velocity += rope_force
		
		var perpendicular = Vector2(-to_hook.y, to_hook.x).normalized()
		velocity = perpendicular * velocity.dot(perpendicular)

	if current_length <= rope_length * 1.1:
		var swing_direction = to_hook.normalized()
		var perpendicular = Vector2(-swing_direction.y, swing_direction.x)
		
		var control_factor = max(cos(angle_from_vertical), 0.1) * 0.5
		if Input.is_action_pressed("right") and angle_from_vertical < PI/2.1:
			velocity += perpendicular * SWING_FORCE * control_factor
		if Input.is_action_pressed("left") and angle_from_vertical < PI/2.1:
			velocity -= perpendicular * SWING_FORCE * control_factor
	
	var vertical_resistance = 0.97 if velocity.y < 0 else 0.99
	velocity *= vertical_resistance
	
	var max_speed = 800
	velocity = velocity.limit_length(max_speed)
	
	if is_on_floor() or is_on_wall():
		release_hook()
		return
		
	if Input.is_action_just_pressed("shoot_hook"):
		release_hook()     

func update_rope_visual() -> void:
	if hook_state != "idle":
		var hook_vector = (hook_target - global_position) * 2
		rope_line.clear_points()
		rope_line.add_point(Vector2.ZERO)
		rope_line.add_point(hook_vector)
		
		if rope_line.material:
			var length = hook_vector.length()
			rope_line.material.set_shader_parameter("waviness", min(length / 100.0, 3.0))
	else:
		rope_line.clear_points()

func release_hook() -> void:
	hook_state = "idle"
	hook_point.visible = false
	hook_point.position = Vector2.ZERO
	rope_line.clear_points()

func gravity(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta

func current_camera() -> void:
	if global.current_scene == "village":
		$CameraVillage.enabled = true
		$CameraTower.enabled = false
	elif global.current_scene == "tower":
		$CameraVillage.enabled = false
		$CameraTower.enabled = true

func explosion(energy: float) -> void:
	energyExplosion = energy

func player() -> void:
	pass
