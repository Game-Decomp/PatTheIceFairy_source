extends Camera2D

var cirno_stack = []

var zoom_on = false
var target_pos: Vector2


func _process(delta):
	while (cirno_stack.size() > 0 and cirno_stack[0] == null):
		cirno_stack.pop_front()
	
	zoom_on = cirno_stack.size() > 0
	
	if zoom_on:
		target_pos = cirno_stack[0].global_position + Vector2(0, - 100)
		zoom = lerp(zoom, Vector2(0.8, 0.8), 0.1)
		global_position = lerp(global_position, target_pos, 0.025)
	else:
		zoom = lerp(zoom, Vector2(1, 1), 0.1)
		global_position = lerp(global_position, Vector2(720, 540), 0.125)
	
	global_position.x = 720 + clamp(
		global_position.x - 720, 
		- 720 * (1 - zoom.x), 
		720 * (1 - zoom.x)
	)
	
	global_position.y = 540 + clamp(
		global_position.y - 540, 
		- 540 * (1 - zoom.y), 
		540 * (1 - zoom.y)
	)


func _on_Cirno_pat_active(cirno):
	if not cirno_stack.has(cirno):
		cirno_stack.push_front(cirno)


func _on_Cirno_pat_stop(cirno):
	cirno_stack.erase(cirno)
