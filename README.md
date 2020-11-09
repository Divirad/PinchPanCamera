# PinchPanCamera
[![Version badge](https://img.shields.io/badge/Version-v0.2.2-green.svg)](https://paypal.me/divirad)  [![Version badge](https://img.shields.io/badge/Godot_Version-v3.2.3stable-green.svg)](https://godotengine.org)  <br>

![](https://img.shields.io/github/downloads/divirad/PinchPanCamera/total)
![](https://img.shields.io/github/stars/Divirad/PinchPanCamera)
![](https://img.shields.io/github/issues/Divirad/PinchPanCamera)
![](https://img.shields.io/github/forks/Divirad/PinchPanCamera)
![](https://img.shields.io/github/license/Divirad/PinchPanCamera) <br>
	
[![Author badge](https://img.shields.io/badge/Made_by-Divirad-inactive.svg)](https://divirad.com) 
[![PayPal badge](https://img.shields.io/badge/Donate-PayPal-blue.svg)](https://paypal.me/divirad) <br>

![Icon](https://raw.githubusercontent.com/Divirad/PinchPanCamera/master/icon.png)

Godot Plugin for a touchscreen optimized camera control system for common 2D top-down strategy games. 
(Works also with mouse when `Emulate Touch with Mouse` is enabled)

![](https://thumbs.gfycat.com/TautLawfulHerald-size_restricted.gif)

[Source of Demo Map](https://forums.wesnoth.org/viewtopic.php?t=40059)

# Usage 
1) Download the `addons/ppc` folder and put it into your addons folder of your project.
2) Enable the PinchPancamera Plugin in your Project Settings
3) Add the PinchPanCamera Node to your Project like a regular Camera (`2DNode/Position2D/PinchPanCamera`)
4) Credit us in your Game, pls :)

# Short Documentation

# Export Variables
```Enable Pinch Pan : bool```

enables functionallity of the PinchPanCamera Node 

```Slide Mode : int```
Select between Normal, only-Horizontal and only-Vertical slide Mode

```current : bool```

if current is true, the PPC Node is the current Camera

```natural slide : bool```

if false it inverts the input

```smoothing : bool```

enables smooth dragging

```smoothing_speed : int```

the smoothness while dragging

```min_zoom_factor : float```
```max_zoom_factor: float```

zoom limit to prevent "infinite-zoom"

```drag_deadzone : Vector2```

deadzone of dragging

```show_debug_icon : bool``` 

shows with the ppc icon the position of the `Position2D` for debugging purposes

# Signals

```zoom_in()``` 

throws when user is zooming in

```zoom_out()``` 

throws when user is zooming out 

```just_pressed()``` 

throws when user touched the screen the first time before dragging

```dragging()``` 

throws when user is dragging the camera
