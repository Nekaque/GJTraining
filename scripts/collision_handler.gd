extends Node

var collisions = 0
var tutorial = true
@onready var music = $Music
@onready var sfx = $SFX

func _ready() -> void:
	pass

func set_volume(volume):
	_ready()
	music.volume_db = volume
	sfx.volume_db = volume
