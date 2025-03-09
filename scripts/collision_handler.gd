extends Node

var collisions = 0
var tutorial = true


func _on_music_ready() -> void:
	$Music.volume_db = 0


func _on_sfx_ready() -> void:
	$SFX.volume_db = 0
