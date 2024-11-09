extends AnimationTree

@onready var animation_tree: AnimationTree = $"."
@onready var player: CharacterBody2D = $"../../.."
var last_facing_dir : Vector2
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	var idle = player.velocity.normalized() != Vector2(0,0)
	if idle:
		last_facing_dir = player.velocity.normalized()
	
	var on_the_ground : bool = player.is_on_floor()
	animation_tree.set("parameters/Ground/blend_position", last_facing_dir.x if idle else (last_facing_dir.x * 0.01))
	animation_tree.set("parameters/Air/blend_position", last_facing_dir)
	animation_tree.set("parameters/conditions/air", !on_the_ground)
	animation_tree.set("parameters/conditions/ground", on_the_ground)
