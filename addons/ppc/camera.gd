extends Camera2D

const MAX_POINTS = 10

var points : Array = []

var last_dist = 0
var current_dist = 0
var zoom_rate = 0.1
var zoom_started : bool = false
var drag_started = false
var input_count = 0

signal on_zoom(val)

func _ready():
	for i in range(MAX_POINTS):
		points.append({pos = Vector2(), start_pos = Vector2(), state = false})
	connect("on_zoom", self, "zoom_this")

func _input(event):
	
	if event is InputEventScreenDrag:
		points[event.index].pos = event.position
	if event is InputEventScreenTouch:
		
		points[event.index].state = event.pressed
		points[event.index].pos = event.position
		if event.pressed:
			points[event.index].start_pos = event.position
	var count = 0
	for point in points:
		if point.state:
			count += 1
	if event is InputEventScreenTouch:
		if !event.pressed and count < 2:
			current_dist = 0
			last_dist = 0
			zoom_started = true
		if event.pressed and count == 2:
			zoom_started = true
	if count == 1:
		handle_drag(event)
		pass
	if count == 2:
		handle_zoom(event)
	input_count = count

func handle_drag(event):
	#position.x = position.x + (points[0].pos.x - points[0].start_pos.x) * zoom.x * 0.01 # - 
	#position.y = position.y + (points[0].pos.y -points[0].start_pos.y ) * zoom.y * 0.01 #- 
	pass

func handle_zoom(event):
	if event is InputEventScreenDrag:
			var part1 = (points[0].pos.y - points[1].pos.y) 
			var part2 = (points[0].pos.x - points[1].pos.x) 
			var distance = sqrt(part1 * part1 + part2 * part2)
			if zoom_started:
				zoom_started = false
				last_dist = distance
				current_dist = distance
			else:
				current_dist = last_dist - distance
				last_dist = distance
			emit_signal("on_zoom", current_dist)

func zoom_this(val):
	if abs(current_dist) > 0.1 and abs(current_dist) < 20:
		var temp_zoom = current_dist * zoom_rate
		zoom.x = clamp(zoom.x + temp_zoom * .025, 0.4, 2)
		zoom.y = clamp(zoom.y + temp_zoom * .025, 0.4, 2)
	
func get_camera_center():
	var vtrans = get_canvas_transform()
	var top_left = -vtrans.get_origin() / vtrans.get_scale()
	var vsize = get_viewport_rect().size
	return top_left + 0.5 * vsize/vtrans.get_scale()
