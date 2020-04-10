# PinchPanCamera
[![Version badge](https://img.shields.io/badge/Version-v0.2-green.svg)](http://paypal.me/divirad)  
![](https://img.shields.io/github/downloads/divirad/PinchPanCamera/total)
![](https://img.shields.io/github/stars/Divirad/PinchPanCamera)
![](https://img.shields.io/github/issues/Divirad/PinchPanCamera)
![](https://img.shields.io/github/forks/Divirad/PinchPanCamera)
![](https://img.shields.io/github/license/Divirad/PinchPanCamera) <br>
	
[![Author badge](https://img.shields.io/badge/Made_by-Divirad-inactive.svg)](http://divirad.com) 
[![PayPal badge](https://img.shields.io/badge/Donate-PayPal-blue.svg)](http://paypal.me/divirad) <br>

![Icon](https://raw.githubusercontent.com/Divirad/PinchPanCamera/master/icon.png)

Godot Plugin for a touchscreen optimized camera control system for common 2D top-down strategy games. 
(Works also with mouse when `Emulate Touch with Mouse` is enabled)

![](https://thumbs.gfycat.com/TautLawfulHerald-small.gif)

[Source of Demo Map](https://forums.wesnoth.org/viewtopic.php?t=40059)

# Usage 
1) Download the `addons/ppc` folder and put it into your addons folder of your project.
2) Enable the PinchPancamera Plugin in your Project Settings
3) Add the PinchPanCamera Node to your Project like a regular Camera (`2DNode/Position2D/PinchPanCamera`)
4) Credit us in your Game, pls :)

# Short Documentation

# export variables
```enabled : bool```

enables functionallity of the PinchPanCamera Node 

```natural_slide : bool```

if false it inverts the input

```current : bool```

if current is true, the PPC Node is the current Camera

```smoothing : bool```

enables smoothe dragging

```smoothing_speed : int```

the smoothness while dragging


```min_zoom_factor : float```
```max_zoom_factor: float```

zoom limit to prevent "infinite-zoom"

```drag_deadzone_x : float```
```drag_deadzone_y : float```

deadzone of dragging

```show_debug_icon : bool``` 

shows with the ppc icon the position of the `Position2D` for debugging purposes
