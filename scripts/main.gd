extends Node

var item = preload("res://scenes/item.tscn")
var dragging = null
var items = []
var occupied  = [true, true, true, true, true]
var rest
var score
var time
var scale
var random = RandomNumberGenerator.new()
var probs = [10, 10, 0, 0, 1, 2, 2,3 ,5]
var shake = false
@onready var timer = $Timer
@onready var label = $Label

func _ready() -> void:
	generate()
	$Tutorial.visible = Coll.tutorial
	get_tree().paused = Coll.tutorial

func generate():
	scale = Vector2(1,1)
	time = 5
	score = 0
	for i in len(occupied): create_item(i)
	timer.wait_time = time
	timer.start(0)
	rest = time
	var t = int(rest)
	label.text = 'Next item in '+str(t)
	$End/Score.text = str(score)
	

func create_item(i):
	var temp = item.instantiate()
	temp.setup(i, random.rand_weighted(probs))
	add_child(temp)
	items.push_front(temp)
	occupied[i] = true

func shake_screen():
	var order = 0.3
	const max_shake = 5
	const max_roll = 0.5
	$Cam.rotation = max_roll * order * randfn(-1, 1)
	$Cam.position = Vector2(512+randfn(-1,1.2)*max_shake*order, 384+randfn(-1,1.2)*max_shake*order)
	
func shaking():
	shake = true
	var tt = get_tree().create_timer(0.3)
	await tt.timeout
	shake = false

func _process(delta: float) -> void:
	if shake: shake_screen()
	else: $Cam.position = Vector2(512,384)
	if dragging: dragging.position = get_viewport().get_mouse_position()
	rest -= delta
	var t = int(rest)+1
	label.text = 'Next item in '+str(t)

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.is_action_pressed('click'):
			if (!dragging):
				for it in items:
					if it.mouse_in:
						if it.movable:
							dragging = it
							dragging.global_scale = scale
							break
						else: shaking()
		elif dragging:
			if Coll.collisions >= 1 or !dragging.on_table:
				dragging.position = dragging.init_pos
				if (dragging.from >= 0): dragging.global_scale = Vector2(0.25,0.25)
				dragging = null
			else: 
				dragging.init_pos = dragging.position
				if (dragging.from >= 0):
					score+=1
					if (score%5 == 0):
						scale*=1.1
						time -= 1
					$End/Score.text = str(score)
					occupied[dragging.from] = false
					dragging.placed()
				dragging = null
	if (event.is_action_pressed("rotate") and dragging): dragging.rotate(deg_to_rad(90))


func _on_timer_timeout() -> void:
	var valid = false
	for i in len(occupied):
		if !(occupied[i]):
			valid = true
			create_item(i)
			break
	if valid:
		rest = time
		timer.wait_time = time
		timer.start(0)
	else:
		label.text = 'get rekt'
		$End.visible = true
		dragging = null
		get_tree().paused = true


func _on_texture_button_pressed() -> void:
	$Tutorial.visible = false
	Coll.tutorial = false
	get_tree().paused = false


func _on_button_pressed() -> void:
	get_tree().paused = false
	while len(items) > 0:
		var it = items.pop_back()
		it.queue_free()
	$End.visible = false
	generate()


func _on_button_2_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/menu.tscn")
