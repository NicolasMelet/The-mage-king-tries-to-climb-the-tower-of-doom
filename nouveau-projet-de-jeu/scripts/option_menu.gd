extends Control

@onready var master_vol = $MarginContainer/VBoxContainer/VBoxContainer/MarginContainer/VBoxContainer/Volume_master as HSlider
@onready var music_vol = $MarginContainer/VBoxContainer/VBoxContainer/MarginContainer/VBoxContainer/Volume_music as HSlider
@onready var sfx_vol = $MarginContainer/VBoxContainer/VBoxContainer/MarginContainer/VBoxContainer/Volume_sfx as HSlider

@onready var resolutions =  $MarginContainer/VBoxContainer/VBoxContainer/MarginContainer2/VBoxContainer/Resolutions as OptionButton
@onready var fullscreen =  $MarginContainer/VBoxContainer/VBoxContainer/MarginContainer2/VBoxContainer/FullScreen as CheckButton
@onready var isFullscreen : bool = DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_FULLSCREEN

func handle_resolution() -> void:
	master_vol.value = db_to_linear(AudioServer.get_bus_volume_db(0))
	music_vol.value = db_to_linear(AudioServer.get_bus_volume_db(1))
	sfx_vol.value = db_to_linear(AudioServer.get_bus_volume_db(2))
	if isFullscreen: 
		resolutions.select(-1)
	else:
		fullscreen.button_pressed = false
		resolutions.disabled = false
		match DisplayServer.window_get_size():
			Vector2i(1920,1080):
				resolutions.select(0)
			Vector2i(1600,900):
				resolutions.select(1)
			Vector2i(1280,720):
				resolutions.select(2)

func _ready() -> void:
	handle_resolution()

func _on_exit_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/menu.tscn");

func _on_resolutions_item_selected(index: int) -> void:
	match index:
		0:
			DisplayServer.window_set_size(Vector2i(1920,1080))
		1:
			DisplayServer.window_set_size(Vector2i(1600,900))
		2:
			DisplayServer.window_set_size(Vector2i(1280,720))

func _on_full_screen_toggled(toggled_on: bool) -> void:
	resolutions.disabled = toggled_on
	handle_resolution()
	DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN if toggled_on else DisplayServer.WINDOW_MODE_WINDOWED)

func _on_mute_toggled(toggled_on: bool) -> void:
	AudioServer.set_bus_mute(0, toggled_on)

func _on_volume_master_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(0,linear_to_db(value))

func _on_volume_music_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(1,linear_to_db(value))

func _on_volume_sfx_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(2,linear_to_db(value))
