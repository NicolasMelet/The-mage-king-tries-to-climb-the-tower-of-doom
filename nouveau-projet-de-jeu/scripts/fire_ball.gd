extends Area2D

@export var FIRE_BALL_SPEED = 300.0


func _physics_process(delta: float) -> void:
	position += transform.x * FIRE_BALL_SPEED * delta

func _on_body_entered(body: Node) -> void:
	print("boom")
	queue_free()
