class_name TouchZoomCamera2D extends Camera2D

## maximum of touched points
const MAX_POINTS = 10

## touched points on screen
var points: Array = []

var last_dist: float = 0
var current_dist: float = 0
var zoom_rate : float = 0.1
var zoom_started: bool = false
var drag_started: bool = false
var input_count: int = 0

var invert_zoom: bool = false

signal on_zoom(val: float)

func _ready() -> void:
	for i in range(MAX_POINTS):
		points.append({pos = Vector2(), start_pos = Vector2(), state = false})
	on_zoom.connect(zoom_this)

func _input(event: InputEvent) -> void:
	if event is InputEventScreenDrag:
		points[event.index].pos = event.position
	if event is InputEventScreenTouch:
		
		points[event.index].state = event.pressed
		points[event.index].pos = event.position
		if event.pressed:
			points[event.index].start_pos = event.position
	var count: int = 0
	for point: Dictionary in points:
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

func handle_drag(event: InputEvent) -> void:
	## is currently happening in ppcamera parent class
	pass


## an external  function that handles the zoom via touchscreen
## for use in the _input(event) method
func handle_zoom(event: InputEvent) -> void:
	if event is InputEventScreenDrag:
		var part1 : float = (points[0].pos.y - points[1].pos.y)
		var part2 : float = (points[0].pos.x - points[1].pos.x)
		var distance : float = sqrt(part1 * part1 + part2 * part2)
		if zoom_started:
			zoom_started = false
			last_dist = distance
			current_dist = distance
		else:
			current_dist = last_dist - distance
			last_dist = distance
		on_zoom.emit(current_dist)


func zoom_this(val: float) -> void:
	if abs(current_dist) > 0.1 and abs(current_dist) < 20:
		var inverter: int = -1 if invert_zoom else 1
		var temp_zoom: float = current_dist * zoom_rate * inverter
		# FIXME: get rid of magic numbers,
		# magic can be great, but only if someone can understand it ✨
		zoom.x = clamp(zoom.x + temp_zoom * .025, 0.4, 2)
		zoom.y = clamp(zoom.y + temp_zoom * .025, 0.4, 2)
	
func get_camera_center() -> Vector2:
	var vtrans: Transform2D = get_canvas_transform()
	var top_left: Vector2 = -vtrans.get_origin() / vtrans.get_scale()
	var vsize: Vector2 = get_viewport_rect().size
	return top_left + 0.5 * vsize / vtrans.get_scale()
