extends Area2D

var mouse_in = false
var movable = true
var init_pos = null
var on_table = false
var from = -1
var animations = ['steak', 'book', 'coffee', 'can', 'pc']
var type = -1

@onready var sprite = $Sprite
	
func _on_mouse_entered() -> void:
	mouse_in = true

func _on_mouse_exited() -> void:
	mouse_in = false

func _on_area_entered(area: Area2D) -> void:
	if (area.is_in_group('Items')): Coll.collisions +=1

func _on_area_exited(area: Area2D) -> void:
	if (area.is_in_group('Items')): Coll.collisions -=1

func _on_table_colider_area_entered(area: Area2D) -> void:
	if (area.name == 'Table'): on_table = true

func _on_table_colider_area_exited(area: Area2D) -> void:
	if (area.name == 'Table'): on_table = false
	
func start_animation():
	sprite.play()

func setup(i, num):
	$Sprite.animation = animations[num]
	position = Vector2(70, i*142 + 112)
	init_pos = position
	from = i
	type = num
	
