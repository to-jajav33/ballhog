########## i have failed to translate RedBlob's hex library to gdscript

# here are links to different language implementations
# C#: 			https://www.redblobgames.com/grids/hexagons/codegen/output/lib.cs
# typescript: 	https://www.redblobgames.com/grids/hexagons/codegen/output/lib.ts
# Python: 		https://www.redblobgames.com/grids/hexagons/codegen/output/lib.py

# note: i have left out the funcionts for "offset" and "doubled" coordinate systems for hexes
# i think we should we use the Axial/Cube coordinate system.


class Layout:
	
	var _point_class = load("res://RedBlob Hex/Point.gd")
	var _hex_class = load("res://RedBlob Hex/Point.gd")
	var _orientation_class = load("res://RedBlob Hex/Point.gd")
	
	var _orientation
	var _size
	var _origin
	func _init(orientation, size, origin):
		_orientation = orientation
		_size = size
		_origin = origin
	var layout_pointy = _orientation_class.new(sqrt(3.0), sqrt(3.0) / 2.0, 0.0, 3.0 / 2.0, sqrt(3.0) / 3.0, -1.0 / 3.0, 0.0, 2.0 / 3.0, 0.5)
	var layout_flat = _orientation_class.new(3.0 / 2.0, 0.0, sqrt(3.0) / 2.0, sqrt(3.0), 2.0 / 3.0, 0.0, -1.0 / 3.0, sqrt(3.0) / 3.0, 0.0)
	
	func hex_to_pixel(layout, h):
		var M = layout.orientation
		var size = layout.size
		var origin = layout.origin
		var x = (M.f0 * h.q + M.f1 * h.r) * size.x
		var y = (M.f2 * h.q + M.f3 * h.r) * size.y
		return _point_class.new(x + origin.x, y + origin.y)

	func pixel_to_hex(layout, p):
		var M = layout.orientation
		var size = layout.size
		var origin = layout.origin
		var pt = _point_class.new((p.x - origin.x) / size.x, (p.y - origin.y) / size.y)
		var q = M.b0 * pt.x + M.b1 * pt.y
		var r = M.b2 * pt.x + M.b3 * pt.y
		return _hex_class.new(q, r, -q - r)

	func hex_corner_offset(layout, corner):
		var M = layout.orientation
		var size = layout.size
		var angle = 2.0 * PI * (M.start_angle - corner) / 6.0
		return _point_class.new(size.x * cos(angle), size.y * sin(angle))

	func polygon_corners(layout, h):
		var corners = []
		var center = hex_to_pixel(layout, h)
		for i in range(0, 6):
			var offset = hex_corner_offset(layout, i)
			corners.append(_point_class.new(center.x + offset.x, center.y + offset.y))
		return corners





