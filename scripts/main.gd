extends Node

var pressed = false
var entered = false
var item = preload("res://scenes/item.tscn")
var dragging = null
var items = null
var occupied = null
var collided = 0
var rest = 0
var time = 5
var end = false
@onready var timer = $Timer
@onready var label = $Label


func _ready() -> void:
	var n = 5
	items = []
	occupied = []
	for i in range(n):
		var temp = item.instantiate()
		temp.setup(i,randi_range(0,1))
		occupied.append(true)
		add_child(temp)
		items.append(temp)
	timer.start(0)
	rest = time

func _process(delta: float) -> void:
	if (!end):
		if dragging:
			dragging.position = get_viewport().get_mouse_position()
		rest -= delta
		var t = int(rest)+1
		label.text = 'Next item in '+str(t)

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and !end:
		if event.button_index == MOUSE_BUTTON_LEFT :
			if event.is_action_pressed('click'):
				for it in items:
					if it.mouse_in and it.movable:
						dragging = it
			else:
				if Coll.collisions >= 1 or !dragging.on_table:
					dragging.position = dragging.init_pos
				else: 
					dragging.init_pos = dragging.position
					if (dragging.from >= 0):
						occupied[dragging.from] = false
						dragging.from = -1
						dragging.start_animation()
				dragging = null


func _on_timer_timeout() -> void:
	var valid = false
	for i in len(occupied):
		if !(occupied[i]):
			var temp = item.instantiate()
			temp.setup(i,randi_range(0,1))
			occupied[i] = true
			add_child(temp)
			items.append(temp)
			valid = true
			break
	if valid:
		rest = time
		timer.start(0)
	else:
		end = true
		label.text = 'get rekt'
