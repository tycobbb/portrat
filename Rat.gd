extends Node2D

# -- props --
# the path to draw over the rat
var m_path: Path2D

# the current drawing speed
var m_draw_speed: float

# the draw speed in units / s
var m_draw_speed_scale: float = 100.0

# if the mouse is pressed
var m_is_pressed: bool

# -- lifecycle --
func _ready():
	m_path = get_node("Path")

func _process(time):
	draw_rat(time)

func _draw():
	draw_polyline(m_path.curve.get_baked_points(), Color.white, 10.0, true)

func _input(evt):
	if evt is InputEventMouseButton:
		on_mouse_button(evt)
	elif evt is InputEventMouseMotion:
		on_mouse_move(evt)

# -- commands --
# draw the rat a little bit
func draw_rat(time: float):
	if m_draw_speed == 0.0:
		return
		
	var c: Curve2D = m_path.curve
	
	# if we have points to move
	if c.get_point_count() < 2:
		return
	
	# get the next two points
	var p0 = c.get_point_position(0)
	var p1 = c.get_point_position(1)
	
	# get the move distance
	var delta = p1 - p0
	var d_len = m_draw_speed * time
	var d_max = delta.length()

	# if the remaining distance is shorter, remove the point
	if d_max < d_len:
		c.remove_point(0)
	# otherwise, move the p0 towards p1
	else:
		p0 += delta.normalized() * d_len
		c.set_point_position(0, p0)
	
	# update state
	m_draw_speed = 0.0
	
	# trigger an update
	update()

# -- events --
# capture mouse press
func on_mouse_button(event: InputEventMouseButton):
	m_is_pressed = event.pressed
	m_draw_speed = 0.0

# capture mouse move
func on_mouse_move(event: InputEventMouseMotion):
	if m_is_pressed:
		m_draw_speed = event.speed.length() * m_draw_speed_scale
	
