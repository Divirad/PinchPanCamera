"""
  _____ _            _       _____            
 |  __ (_)          | |     |  __             
 | |__) | _ __   ___| |__   | |__) |_ _ _ __  
 |  ___/ | '_ | / __| '_ |  |  ___/ _` | '_ | 
 | |   | | | | | (__| | | | | |  | (_| | | | |
 |_|   |_|_| |_| ___|_| |_| |_|    __,_|_| |_|
   _____                               
  / ____|                              
 | |     __ _ _ __ ___   ___ _ __ __ _ 
 | |    / _` | '_ ` _ | / _ | '__/ _` |
 | |___| (_| | | | | | |  __/ | | (_| |
   _____ __,_|_| |_| |_| ___|_|   __,_|

A touchscreen optimized camera control system 
for common 2D top-down strategy games.

Licensed under MIT

v. 0.2.2

Author: Max Schmitt 
		from
		Divirad - Kepper, Lösing, Schmitt GbR
"""

extends Position2D
class_name PinchPanCamera, "icon.png"

export var enable_pinch_pan : bool = true
export (int, "Normal", "Horizontal", "Vertical") var slide_mode = 0
export var current : bool = true
export var smoothing : bool = true
export var smoothing_speed : int = 10
export var natural_slide : bool = true

export var min_zoom_factor : float = 0.6
export var max_zoom_factor: float = 2
export var drag_deadzone : Vector2 = Vector2(0.1, 0.1)

export var show_debug_icon : bool = false

var shop
var start_position 
var already_pressed = false
var min_zoom : Vector2 = Vector2(0, 0)
var max_zoom : Vector2 = Vector2(0, 0)
var naturalizer = 1

var camera : Camera2D

signal zoom_in()
signal zoom_out()
signal just_pressed()
signal dragging()

signal input_number(num)

func _enter_tree():
	"""
	initializes all the export variables 
	"""
	
	min_zoom = Vector2(min_zoom_factor, min_zoom_factor)
	max_zoom = Vector2(max_zoom_factor, max_zoom_factor)
	
	var c = load("res://addons/ppc/camera.tscn")
	add_child(c.instance())
	camera = get_node("camera")
	
	camera.drag_margin_left = drag_deadzone.x
	camera.drag_margin_right = drag_deadzone.x
	camera.drag_margin_top = drag_deadzone.y
	camera.drag_margin_bottom = drag_deadzone.y
	
	camera.current = current
	camera.smoothing_enabled = smoothing
	camera.smoothing_speed = smoothing_speed
	
	if show_debug_icon:
		var di = load("res://addons/ppc/testicon.tscn")
		add_child(di.instance())

func _process(_delta):
	
	if camera.drag_margin_left != drag_deadzone.x \
	and camera.drag_margin_right != drag_deadzone.x:
		camera.drag_margin_left = drag_deadzone.x
		camera.drag_margin_right = drag_deadzone.x
	
	if camera.drag_margin_top != drag_deadzone.y \
	and camera.drag_margin_bottom != drag_deadzone.y:
		camera.drag_margin_top = drag_deadzone.y
		camera.drag_margin_bottom = drag_deadzone.y
	
	if camera.current != current:
		camera.current = current
		
	if smoothing != camera.smoothing_enabled:
		camera.smoothing_enabled = smoothing

	if camera.smoothing_speed != smoothing_speed:
		camera.smoothing_speed = smoothing_speed

	if min_zoom != Vector2(min_zoom_factor, min_zoom_factor):
		min_zoom = Vector2(min_zoom_factor, min_zoom_factor)

	if max_zoom != Vector2(max_zoom_factor, max_zoom_factor):
		max_zoom = Vector2(max_zoom_factor, max_zoom_factor)
	
	# inverts inputs
	if natural_slide and naturalizer != 1:
		naturalizer = 1
	elif !natural_slide and naturalizer != -1:
		naturalizer = -1


func _input(event):
	
	if !enable_pinch_pan:
		return
	# Handle MouseWheel for Zoom
	if event is InputEventMouseButton and event.is_pressed():
		if event.button_index == BUTTON_WHEEL_UP:
			emit_signal("zoom_in")
			if camera.zoom >= min_zoom:
				camera.zoom -= Vector2(0.1, 0.1)
		if event.button_index == BUTTON_WHEEL_DOWN:
			emit_signal("zoom_out")
			if camera.zoom <= max_zoom:
				camera.zoom += Vector2(0.1, 0.1)
	
	# Handle Touch
	if event is InputEventScreenTouch:
		if event.is_pressed() and !already_pressed:
			emit_signal("just_pressed")
			start_position = get_norm_coordinate() * naturalizer
			already_pressed = true
		if !event.is_pressed():
			already_pressed = false

	# Handles ScreenDragging
	if event is InputEventScreenDrag:
		if camera.input_count == 1:
			emit_signal("dragging")
			if natural_slide:
				position += get_movement_vector_from(get_local_mouse_position())
				start_position = get_local_mouse_position()
			else:
				var coord = get_movement_vector_from(-get_norm_coordinate())
				position += coord
	# Handles releasing
	if  camera.input_count == 0:
		
		position = camera.get_camera_center() 
		

func get_movement_vector_from(vec : Vector2) -> Vector2:
	"""
	calculates a vector for the movement
	"""
	var move_vec = start_position - vec 
	
	
	if slide_mode == 1:
		return Vector2(move_vec.x, 0)
	if slide_mode == 2:
		return Vector2(0, move_vec.y)
	else:
		return move_vec

func get_norm_coordinate() -> Vector2:
	"""
	gets the normalized coordinate of a touch
	"""
	var result 
	if natural_slide:
		result = get_global_mouse_position() - camera.get_camera_center()
	else:
		result = get_local_mouse_position() - camera.get_camera_center()
	return result
		
func invert_vector(vec : Vector2):
	"""
	inverts a vector
	"""
	return Vector2(-vec.x, -vec.y)
