extends Area2D

var mouse_in = false
var movable = true
var init_pos = null
var on_table = false
var from = -1

func _on_mouse_entered() -> void:
	mouse_in = true
	print(mouse_in)

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
	$Sprite.animation.autoplay = true
