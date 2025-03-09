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
# ['steak', 'book', 'coffee', 'can', 'pc', 'cactus', 'pencil', 'pen', 'plant']
var probs = [1, 0.6, 3, 3, 0.2, 0.3, 1.2, 1.2, 0.7, 0.5, 5, 0.5, 0.5, 1]
var shake = false
var holding = load("res://assets/buttons/hand_holding.png")
var default = load("res://assets/buttons/hand_default.png")
var no_table = load("res://assets/buttons/hand_nontable.png")
var table = load("res://assets/buttons/hand_table.png")
var hover = load("res://assets/buttons/hand_hover.png")
var kolecka_barvy = ['green', 'yellow', 'green', 'green', 'red', 'red', 'yellow', 'yellow', 'yellow', 'blue', 'blue', 'blue', 'blue', 'blue']
@onready var kolecka = [$kolecka/kolecko1, $kolecka/kolecko2, $kolecka/kolecko3, $kolecka/kolecko4, $kolecka/kolecko5]
@onready var powerups_icons = [$powerups_ukazatel/steak_rdy, $powerups_ukazatel/book_rdy, $powerups_ukazatel/coffee_rdy, $powerups_ukazatel/can_rdy]
@onready var timer = $Timer
@onready var label = $Label

func _ready() -> void:
	tut(true)
	generate()
	
func tut(show):
	$Tutorial.visible = show
	get_tree().paused = show
	

func generate():
	scale = Vector2(0.8, 0.8)
	time = 5
	score = 0
	for i in len(occupied):
		Coll.is_stackable[i] = false
		create_item(i)
	timer.wait_time = time
	timer.start(0)
	rest = time
	var t = int(rest)
	label.text = str(t)
	$End/Score.text = str(score)
	

func create_item(i):
	var temp = item.instantiate()
	var rnd_weighted = random.rand_weighted(probs)
	temp.setup(i, rnd_weighted)
	add_child(temp)
	items.push_front(temp)
	kolecka[i].play(kolecka_barvy[rnd_weighted])
	occupied[i] = true
	$Music/Item_arrives.play()

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
	if dragging:
		dragging.position = get_viewport().get_mouse_position()
		print(dragging.on_table)
		if (dragging.on_table and (Coll.collisions == 0 or dragging.type == 13)): Input.set_custom_mouse_cursor(table)
		else: Input.set_custom_mouse_cursor(no_table)
	rest -= delta
	var t = int(rest)+1
	label.text = str(t)

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.is_action_pressed('click'):
			if (!dragging):
				for it in items:
					if it.mouse_in:
						if it.movable:
							dragging = it
							dragging.global_scale = scale
							Input.set_custom_mouse_cursor(holding)
							kolecka[dragging.from].play('empty')
							$Music/Pick_up_item.play()
							if dragging.type == 13: dragging.animate()
							break
						else:
							shaking()
		elif dragging:
			Input.set_custom_mouse_cursor(default, 0, Vector2(2,2))
			if Coll.collisions >= 1 or !dragging.on_table:
				if (dragging.type == 13 and dragging.on_table): clean()
				else:
					kolecka[dragging.from].play(kolecka_barvy[dragging.type])
					dragging.position = dragging.init_pos
					if (dragging.from >= 0): dragging.global_scale = Vector2(0.4,0.4)
					if (dragging.type == 13): dragging.first_frame()
					dragging = null
			else:
				dragging.init_pos = dragging.position
				if dragging.type == 13: clean()
				elif dragging.type >=9 and dragging.type <= 12:
					$Music/Upgrade.play()
					powerups_icons[dragging.type-9].visible = true
					Coll.is_stackable[dragging.type-9] = true
					probs[dragging.type] = 0
					occupied[dragging.from] = false
					for i in len(items):
						if (items[i] == dragging):
							items.pop_at(i)
							break
					dragging.queue_free()
					dragging = null
					
				elif (dragging.from >= 0):
					score+=1
					if (score%5 == 0): time -= 0.3
					$End/Score.text = str(score)
					occupied[dragging.from] = false
					dragging.placed()
					$Music/Place_on_table.play()
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
		for i in len(powerups_icons):
			Coll.is_stackable[i] = false
			powerups_icons[i].visible = false
		label.text = 'get rekt'
		$End.visible = true
		dragging = null
		get_tree().paused = true


func _on_texture_button_pressed() -> void:
	tut(false)


func clean():
	$Music/Broom_sweep.play()
	occupied[dragging.from] = false
	var legit = []
	var free = []
	for it in items:
		if (it.collided and it.cleanable) or it == dragging: free.append(it)
		else: legit.append(it)
	for it in free: it.queue_free()
	dragging = null
	items = legit

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

func _on_restart_mouse_entered() -> void: Input.set_custom_mouse_cursor(hover)
func _on_restart_mouse_exited() -> void: Input.set_custom_mouse_cursor(default, 0, Vector2(2,2))
func _on_main_menu_mouse_entered() -> void: Input.set_custom_mouse_cursor(hover)
func _on_main_menu_mouse_exited() -> void: Input.set_custom_mouse_cursor(default, 0, Vector2(2,2))
func _on_cross_mouse_entered() -> void: Input.set_custom_mouse_cursor(hover)
func _on_cross_mouse_exited() -> void: Input.set_custom_mouse_cursor(default, 0, Vector2(2,2))


func _on_help_pressed() -> void:
	tut(true)
