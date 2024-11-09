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
	#if velocity:
		#last_facing_direction = velocity.normalized()
	#
	#if last_facing_direction.x > 0:
		#anim_direction = "right"
	#elif last_facing_direction.x < 0:
		#anim_direction = "left"
	#
	#if velocity.x != 0:
		#animation_player.play("walk_" + anim_direction)
	#else:
		#animation_player.play("idle_" + anim_direction)
