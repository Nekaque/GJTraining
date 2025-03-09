extends Node

var item = preload("res://scenes/item.tscn")
var dragging = null
var items = []
var occupied  = [true, true, true, true, true]
var rest = 0
var score = 0
var time = 50
var random = RandomNumberGenerator.new()
var probs = [4, 5, 0, 0, 10, 4, 4,4 ,4]
var shake = false
@onready var timer = $Timer
@onready var label = $Label

func _ready() -> void:
	generate()
	#get_tree().paused = true

func generate():
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
	items.append(temp)
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
							dragging.global_scale = Vector2(1,1)
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
		timer.start(0)
	else:
		label.text = 'get rekt'
		$End.visible = true
		get_tree().paused = true


func _on_texture_button_pressed() -> void:
	$Tutorial.visible = false
	get_tree().paused = false


func _on_button_pressed() -> void:
	get_tree().paused = false
	while len(items) > 0:
		var it = items.pop_back()
		it.queue_free()
	$End.visible = false
	generate()
