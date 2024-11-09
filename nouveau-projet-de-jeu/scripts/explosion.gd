extends Area2D

@export var EXPLOSION_STRENGTH = 800
var MAX_TIME = 0.3
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
	if (body.is_in_group("Player")):
		body.velocity = global_position.direction_to(body.global_position) * EXPLOSION_STRENGTH
		body.explosion((global_position.direction_to(body.global_position) * EXPLOSION_STRENGTH).x)
