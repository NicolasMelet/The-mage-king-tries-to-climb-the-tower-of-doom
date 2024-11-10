extends Control
@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer

func _on_quit_pressed() -> void:
	get_tree().quit();


func _on_play_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/world.tscn");


func _on_options_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/option_menu.tscn");
