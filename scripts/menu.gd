extends Node2D

var default = load("res://assets/buttons/hand_default.png")
var hover = load("res://assets/buttons/hand_hover.png")

func _ready() -> void:
	Input.set_custom_mouse_cursor(default, 0, Vector2(2,2))

func _on_texture_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/main.tscn")


func _on_play_mouse_entered() -> void:
	Input.set_custom_mouse_cursor(hover)
	


func _on_play_mouse_exited() -> void:
	Input.set_custom_mouse_cursor(default, 0, Vector2(2,2))
