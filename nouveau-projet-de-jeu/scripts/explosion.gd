extends Area2D

@export var EXPLOSION_STRENGTH = 3000
var MAX_TIME = 0.2
var CURRENT_TIME = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	CURRENT_TIME += delta
	if CURRENT_TIME >= MAX_TIME:
		queue_free()


func _on_body_entered(body: Node2D) -> void:
	if body is RigidBody2D:
		var direction = global_position.direction_to(body.global_position)
		body.apply_impulse(EXPLOSION_STRENGTH * direction)
	if (body.is_in_group("Player")):
		@warning_ignore("integer_division")
		body.velocity = global_position.direction_to(body.global_position) * EXPLOSION_STRENGTH / (EXPLOSION_STRENGTH / 800)
		@warning_ignore("integer_division")
		body.explosion((global_position.direction_to(body.global_position) * EXPLOSION_STRENGTH / (EXPLOSION_STRENGTH / 800)).x)
