


########## below is my failure to translate things to gdscript

# frist, a note on redblob:
# i have included two implementations of redblob's hex library in the project folder:
# redblob_hex.js (typescript, actually, but i saved it .js? idk if that's right)
# redblob_hex.py
# see https://www.redblobgames.com/grids/hexagons/implementation.html for more info
# scroll to bottom for links to the implementations



# Commented out python code (the typescript code is after my attempt to translate):
#var Orientation = ["Orientation", ["f0", "f1", "f2", "f3", "b0", "b1", "b2", "b3", "start_angle"]]
#var Layout = ["Layout", ["orientation", "size", "origin"]]



class Layout:
	var _orientation : Orientation
	var _size : Point
	var _origin : Point
	func _init(orientation, size, origin):
		_orientation = orientation
		_size = size
		origin = _origin
	var layout_pointy = load("res://RedBlob Hex/Orientation.gd").new(sqrt(3.0), sqrt(3.0) / 2.0, 0.0, 3.0 / 2.0, sqrt(3.0) / 3.0, -1.0 / 3.0, 0.0, 2.0 / 3.0, 0.5)
	
	
	
	var layout_flat = Orientation(3.0 / 2.0, 0.0, sqrt(3.0) / 2.0, sqrt(3.0), 2.0 / 3.0, 0.0, -1.0 / 3.0, sqrt(3.0) / 3.0, 0.0)
	
	func hex_to_pixel(layout, h):
		M = layout.orientation
		size = layout.size
		origin = layout.origin
		x = (M.f0 * h.q + M.f1 * h.r) * size.x
		y = (M.f2 * h.q + M.f3 * h.r) * size.y
		return Point(x + origin.x, y + origin.y)

	func pixel_to_hex(layout, p):
		M = layout.orientation
		size = layout.size
		origin = layout.origin
		pt = Point((p.x - origin.x) / size.x, (p.y - origin.y) / size.y)
		q = M.b0 * pt.x + M.b1 * pt.y
		r = M.b2 * pt.x + M.b3 * pt.y
		return Hex(q, r, -q - r)

	func hex_corner_offset(layout, corner):
		M = layout.orientation
		size = layout.size
		angle = 2.0 * math.pi * (M.start_angle - corner) / 6.0
		return Point(size.x * math.cos(angle), size.y * math.sin(angle))

	func polygon_corners(layout, h):
		corners = []
		center = hex_to_pixel(layout, h)
		for i in range(0, 6):
			offset = hex_corner_offset(layout, i)
			corners.append(Point(center.x + offset.x, center.y + offset.y))
		return corners





