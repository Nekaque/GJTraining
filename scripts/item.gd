extends Area2D

var mouse_in = false
var init_pos = null
var on_table = false
var movable = true
var cleanable = true
var stackable = false
var from = -1
var animations = ['steak', 'book', 'coffee', 'can', 'pc', 'cactus', 'pencil', 'pen', 'plant', 'steak_up','book_up', 'coffee_up', 'can_up', 'cleanup']
@onready var colliders = [$PlateCollider, $BookCollider, $CoffeeCollider, $CanCollider, $PcCollider, $CactusCollider, $PencilCollider,
$PenCollider, $PlantCollider, $CoffeeCollider, $CoffeeCollider,$CoffeeCollider,$CoffeeCollider, $CoffeeCollider]
@onready var sprite = $Sprite
var type = -1
var hover = load("res://assets/buttons/hand_hover.png")
var default = load("res://assets/buttons/hand_default.png")
var collided = false
var is_cleanable = [true, false, true, true, false, false, false, false, false, false, false, false, false, false]
var is_movable = [true, true, true, true, false, false, true, true, true, false, false, false, false, false]
var is_stackable = [true, true, true, true, false, false, false, false, false, false, false, false, false, false]



func _ready() -> void: pass

func _on_mouse_entered() -> void:
	mouse_in = true
	Input.set_custom_mouse_cursor(hover)

func _on_mouse_exited() -> void:
	mouse_in = false
	Input.set_custom_mouse_cursor(default, 0, Vector2(2,2))

func _on_area_entered(area: Area2D) -> void:
	#print('entered: ', area.name)
	#print('collisions: ', Coll.collisions)
	#print('from: ', from)
	if area.is_in_group('Items'):
		collided  = true
		Coll.collisions +=1

func _on_area_exited(area: Area2D) -> void:
	if area.is_in_group('Items'):
		collided = false
		Coll.collisions -=1

func _on_table_colider_area_entered(area: Area2D) -> void:
	if (area.name == 'Table'): on_table = true

func _on_table_colider_area_exited(area: Area2D) -> void:
	if (area.name == 'Table'): on_table = false

func setup(i, num):
	_ready()
	global_scale = Vector2(0.4,0.4)
	sprite.animation = animations[num]
	for collider in colliders: collider.disabled = true
	colliders[num].disabled = false
	cleanable = is_cleanable[num]
	stackable = is_stackable[num]
	position = Vector2(70, i*142 + 112)
	init_pos = position
	from = i
	type = num

func animate(): sprite.play()

func first_frame():
	sprite.play()
	sprite.pause()

func placed():
	from = -1
	movable = false
	sprite.play()
	


func _on_sprite_animation_finished() -> void:
	movable = is_movable[type]
