extends Camera2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var players = get_tree().get_nodes_in_group("Players")
	
	for player in players:
		print(player.position)
		print(limit_right)
		#if player.position.x < position.x:
			#position.x -= limit_right
	pass
