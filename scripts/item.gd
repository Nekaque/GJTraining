extends Area2D

var mouse_in = false
var init_pos = null
var on_table = false
var movable = true
var cleanable = false
var stackable = false
var from = -1
var animations = ['steak', 'book', 'coffee', 'can', 'pc', 'cactus', 'pencil', 'pen', 'plant', 'steak_up','book_up', 'coffee_up', 'can_up', 'cleanup']
@onready var colliders = [$PlateCollider, $BookCollider, $CoffeeCollider, $CanCollider, $PcCollider, $CactusCollider, $PencilCollider,
$PenCollider, $PlantCollider, $CoffeeCollider, $CoffeeCollider,$CoffeeCollider,$CoffeeCollider, $CleanupCollider]
@onready var sprite = $Sprite
var type = -1
var hover = load("res://assets/buttons/hand_hover.png")
var default = load("res://assets/buttons/hand_default.png")
var collided = false
var is_cleanable = [true, false, true, true, false, false, false, false, false, false, false, false, false, false]
var is_movable = [true, true, true, true, false, false, true, true, true, false, false, false, false, true]



func _ready() -> void: pass

func _on_mouse_entered() -> void:
	if (on_table):
		mouse_in = true
		Input.set_custom_mouse_cursor(hover)

func _on_mouse_exited() -> void:
	if (on_table):
		mouse_in = false
		Input.set_custom_mouse_cursor(default, 0, Vector2(2,2))

func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group('Items'):
		if !(Coll.is_stackable[type] and area.is_in_group(animations[type])):
			collided = true
			Coll.collisions +=1

func _on_area_exited(area: Area2D) -> void:
	if area.is_in_group('Items'):
		if !(Coll.is_stackable[type] and area.is_in_group(animations[type])):
			collided = false
			Coll.collisions -=1

func _on_table_colider_area_entered(area: Area2D) -> void:
	if (area.name == 'Table'):
		set_collision_layer_value(1, true)
		set_collision_layer_value(2, false)
		set_collision_mask_value(1, true)
		set_collision_mask_value(2, false)
		on_table = true

func _on_table_colider_area_exited(area: Area2D) -> void:
	if (area.name == 'Table'):
		set_collision_layer_value(1, false)
		set_collision_layer_value(2, true)
		set_collision_mask_value(2, true)
		set_collision_mask_value(1, false)
		on_table = false

func setup(i, num):
	_ready()
	global_scale = Vector2(0.4,0.4)
	if num<=8: rotate(deg_to_rad((randi()%4) * 90))
	sprite.animation = animations[num]
	first_frame()
	for collider in colliders: collider.disabled = true
	add_to_group(animations[num])
	colliders[num].disabled = false
	stackable = Coll.is_stackable[num]
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
	$Area2D/MouseCollision.disabled = true
	


func _on_sprite_animation_finished() -> void:
	movable = is_movable[type]
	cleanable = is_cleanable[type]

func _on_area_2d_mouse_entered() -> void:
	mouse_in = true
	Input.set_custom_mouse_cursor(hover)


func _on_area_2d_mouse_exited() -> void:
	mouse_in = false
	Input.set_custom_mouse_cursor(default, 0, Vector2(2,2))
