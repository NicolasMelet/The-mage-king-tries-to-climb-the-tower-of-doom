extends Area2D

@export var FIRE_BALL_SPEED = 3000.0
@onready var _animated_sprite = $AnimatedSprite2D
@onready var audio_stream_player_2d: AudioStreamPlayer2D = $AudioStreamPlayer2D

const EXPLOSION = preload("res://scenes/Explosion.tscn")
var size = 0

func setSize(newSize):
	size = newSize
	if size == 0:
		get_node("AnimatedSprite2D").scale.x = 3
		get_node("AnimatedSprite2D").scale.y = 3
		get_node("PointLight2D").scale.x = 1
		get_node("PointLight2D").scale.y = 1
	if size == 1:
		get_node("AnimatedSprite2D").scale.x = 5
		get_node("AnimatedSprite2D").scale.y = 5
		get_node("PointLight2D").scale.x = 1.5
		get_node("PointLight2D").scale.y = 1.5
	if size == 2:
		get_node("AnimatedSprite2D").scale.x = 9
		get_node("AnimatedSprite2D").scale.y = 9
		get_node("PointLight2D").scale.x = 2
		get_node("PointLight2D").scale.y = 2

func _ready() -> void:
	_animated_sprite.play("default")
	audio_stream_player_2d.play()

func _physics_process(delta: float) -> void:
	position += transform.x * FIRE_BALL_SPEED * delta

func _on_body_entered(body: Node) -> void:
	if (body.is_in_group("Collide") or body is RigidBody2D):
		var explosion = EXPLOSION.instantiate()
		explosion.set_global_position(global_position)
		explosion.setSize(size)
		get_tree().root.add_child(explosion)
		queue_free()
