extends Node

var collisions = 0
var tutorial = true
var music
var sfx

var collided = []

func _on_music_ready() -> void:
	$Music.volume_db = 0
	music = $Music


func _on_sfx_ready() -> void:
	$SFX.volume_db = 0
	sfx = $SFX
	
