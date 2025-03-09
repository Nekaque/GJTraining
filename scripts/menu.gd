extends Node2D

func _ready() -> void:
	Input.set_custom_mouse_cursor(load("res://assets/buttons/hand_default.png"))

func _on_texture_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/main.tscn")
