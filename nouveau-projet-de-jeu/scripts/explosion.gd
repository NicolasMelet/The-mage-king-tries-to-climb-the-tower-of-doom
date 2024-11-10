extends Area2D

@export var EXPLOSION_STRENGTH = [400, 750, 1000]
@export var EXPLOSION_STRENGTH_ITEMS = [700, 1000, 2000]
var size = 0
var MAX_TIME = 0.3
var CURRENT_TIME = 0

@onready var audio_stream_player_2d: AudioStreamPlayer2D = $AudioStreamPlayer2D

func _ready() -> void:
	audio_stream_player_2d.play()

func setSize(newSize):
	size = newSize
  
func _process(delta: float) -> void:
	CURRENT_TIME += delta
	if CURRENT_TIME >= MAX_TIME:
		queue_free()

func apply_impulse_to_character(character: CharacterBody2D) -> void:
	var direction := global_position.direction_to(character.global_position)
	var impulse = direction * EXPLOSION_STRENGTH[size]
	
	# Add to existing velocity instead of replacing it
	character.velocity += impulse
	# Only pass the X component for horizontal explosion force
	character.explosion(impulse.x)

func apply_explosion_force(body: Node2D) -> void:
	var direction := global_position.direction_to(body.global_position)
	
	if body is RigidBody2D:
		body.apply_impulse(EXPLOSION_STRENGTH_ITEMS[size] * direction)
	elif body is CharacterBody2D:
		apply_impulse_to_character(body)

func _on_body_entered(body: Node2D) -> void:
	apply_explosion_force(body)
