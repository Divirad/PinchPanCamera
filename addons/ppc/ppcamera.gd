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

v. 0.0

Author: Max Schmitt 
		from
		Divirad - Kepper, Lösing, Schmitt GbR
"""

extends Position2D
class_name PinchPanCamera, "icon.png"

export var drag_deadzone : float = 0.1
export var current : bool = true
export var smoothing : bool = false
export var smoothing_speed : int = 10
export var min_zoom_factor : float = 0.6
export var max_zoom_factor: float = 2
export var show_debug_icon : bool = false

var shop
var start_position 
var already_pressed = false
var min_zoom : Vector2 = Vector2(0, 0)
var max_zoom : Vector2 = Vector2(0, 0)

var camera : Camera2D

func _enter_tree():
	"""
	initializes all the export variables 
	"""
	
	min_zoom = Vector2(min_zoom_factor, min_zoom_factor)
	max_zoom = Vector2(max_zoom_factor, max_zoom_factor)
	
	var c = load("res://addons/ppc/camera.tscn")
	add_child(c.instance())
	camera = get_node("camera")
	
	camera.drag_margin_left = drag_deadzone
	camera.drag_margin_top = drag_deadzone
	camera.drag_margin_right = drag_deadzone
	camera.drag_margin_bottom = drag_deadzone
	camera.current = current
	camera.smoothing_enabled = smoothing
	camera.smoothing_speed = smoothing_speed
	
	if show_debug_icon:
		var di = load("res://addons/ppc/testicon.tscn")
		add_child(di.instance())

func _input(event):
	
	# Handle MouseWheel
	if event is InputEventMouseButton and event.is_pressed():

		if event.button_index == BUTTON_WHEEL_UP:
			if camera.zoom >= min_zoom:
				camera.zoom -= Vector2(0.1, 0.1)

		if event.button_index == BUTTON_WHEEL_DOWN:
			if camera.zoom <= max_zoom:
				camera.zoom += Vector2(0.1, 0.1)
	
	# Handle Touch
	if event is InputEventScreenTouch:
		if event.is_pressed() and !already_pressed:
			start_position = get_norm_coordinate()
			already_pressed = true
		if !event.is_pressed():
			already_pressed = false
	if event is InputEventScreenDrag:
		if camera.input_count == 1:
			var coord = get_movement_vector_from(get_norm_coordinate())
			position += coord

	if  camera.input_count == 0:
		position = camera.get_camera_center() 

func get_movement_vector_from(vec : Vector2) -> Vector2:
	"""
	calculates a vector for the movement
	"""
	return vec - start_position

func get_norm_coordinate() -> Vector2:
	"""
	gets the normalized coordinate of a touch
	"""
	return get_local_mouse_position() - camera.get_camera_center()

func invert_vector(vec : Vector2):
	"""
	inverts a vector
	"""
	return Vector2(-vec.x, -vec.y)