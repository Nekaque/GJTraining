extends Node

var pressed = false
var entered = false
var item = preload("res://scenes/item.tscn")
var dragging = null
var items = null
var occupied = null
var collided = 0
var rest = 0
var time = 1
var end = false
var max_type = 4
var random = RandomNumberGenerator.new()
var probs = [1,2,3,4,5]
@onready var timer = $Timer
@onready var label = $Label


func _ready() -> void:
	var n = 5
	items = []
	occupied = [true, true, true, true, true]
	for i in range(n): create_item(i)
	timer.wait_time = time
	timer.start(0)
	rest = time
	
func create_item(i):
	var temp = item.instantiate()
	temp.setup(i, random.rand_weighted(probs))
	add_child(temp)
	items.append(temp)
	occupied[i] = true
	

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
						dragging.global_scale = Vector2(1,1)
			elif dragging:
				if Coll.collisions >= 1 or !dragging.on_table:
					dragging.position = dragging.init_pos
					dragging.global_scale = Vector2(0.25,0.25)
					
				else: 
					dragging.init_pos = dragging.position
					if (dragging.from >= 0):
						occupied[dragging.from] = false
						dragging.from = -1
						dragging.start_animation()
				dragging = null
	if (event.is_action_pressed("rotate") and dragging): dragging.rotate(deg_to_rad(90))


func _on_timer_timeout() -> void:
	var valid = false
	for i in len(occupied):
		#if !(occupied[i]):
		create_item(i)
			#break
	if valid:
		rest = time
		timer.start(0)
	else:
		end = true
		label.text = 'get rekt'


func _on_button_pressed() -> void:
	pass
