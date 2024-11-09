extends Area2D

@export var FIRE_BALL_SPEED = 3000.0
const EXPLOSION = preload("res://scenes/Explosion.tscn")

func _physics_process(delta: float) -> void:
	position += transform.x * FIRE_BALL_SPEED * delta

func _on_body_entered(body: Node) -> void:
	if (body.is_in_group("Collide") or body is RigidBody2D):
		var explosion = EXPLOSION.instantiate()
		explosion.set_global_position(global_position)
		get_tree().root.add_child(explosion)
		queue_free()
