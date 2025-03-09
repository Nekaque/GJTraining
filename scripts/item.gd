extends Area2D

var mouse_in = false
var movable = true
var init_pos = null
var on_table = false
var from = -1
var animations = ['steak', 'book', 'coffee', 'can', 'pc', 'cactus', 'pencil', 'pen', 'plant']
@onready var colliders = [$PlateCollider, $BookCollider, $CoffeeCollider, $CanCollider, $PcCollider, $CactusCollider, $PencilCollider, $PenCollider, $PlantCollider]
@onready var sprite = $Sprite
var type = -1

func _ready() -> void: pass

func _on_mouse_entered() -> void:
	mouse_in = true
	Input.set_default_cursor_shape(Input.CURSOR_POINTING_HAND)

func _on_mouse_exited() -> void:
	mouse_in = false
	Input.set_default_cursor_shape(Input.CURSOR_ARROW)

func _on_area_entered(area: Area2D) -> void:
	if (area.is_in_group('Items') and from == -1): Coll.collisions +=1

func _on_area_exited(area: Area2D) -> void:
	if (area.is_in_group('Items') and from == -1): Coll.collisions -=1

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
	position = Vector2(70, i*142 + 112)
	init_pos = position
	from = i
	type = num

func placed():
	from = -1
	movable = false
	sprite.play()
	


func _on_sprite_animation_finished() -> void:
	if type!= 4: movable = true
