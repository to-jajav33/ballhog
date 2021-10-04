class TextHexes:
	
	var _hex_class = load("res://RedBlob Hex/Point.gd")
	
	func new_hex(q, r, s):
		return _hex_class.new(q, r, s)
		
	func complain(name):
		print("FAIL {0}".format(name))

	func equal_hex(name, a, b):
		if not (a.q == b.q and a.s == b.s and a.r == b.r):
			complain(name)

	func equal_offsetcoord(name, a, b):
		if not (a.col == b.col and a.row == b.row):
			complain(name)

	func equal_doubledcoord(name, a, b):
		if not (a.col == b.col and a.row == b.row):
			complain(name)

	func equal_int(name, a, b):
		if not (a == b):
			complain(name)

	func equal_hex_array(name, a, b):
		equal_int(name, len(a), len(b))
		for i in range(0, len(a)):
			equal_hex(name, a[i], b[i])
			
	func test_hex_arithmetic():
		equal_hex("hex_add", new_hex(4, -10, 6), hex_add(new_hex(1, -3, 2), new_hex(3, -7, 4)))
		equal_hex("hex_subtract", new_hex(-2, 4, -2), hex_subtract(new_hex(1, -3, 2), new_hex(3, -7, 4)))

	func test_hex_direction():
		equal_hex("hex_direction", new_hex(0, -1, 1), hex_direction(2))

	func test_hex_neighbor():
		equal_hex("hex_neighbor", new_hex(1, -3, 2), hex_neighbor(new_hex(1, -2, 1), 2))

	func test_hex_diagonal():
		equal_hex("hex_diagonal", new_hex(-1, -1, 2), hex_diagonal_neighbor(new_hex(1, -2, 1), 3))

	func test_hex_distance():
		equal_int("hex_distance", 7, hex_distance(Hex(3, -7, 4), Hex(0, 0, 0)))

	func test_hex_rotate_right():
		equal_hex("hex_rotate_right", hex_rotate_right(Hex(1, -3, 2)), Hex(3, -2, -1))

	func test_hex_rotate_left():
		equal_hex("hex_rotate_left", hex_rotate_left(Hex(1, -3, 2)), Hex(-2, -1, 3))

	func test_hex_round():
		a = Hex(0.0, 0.0, 0.0)
		b = Hex(1.0, -1.0, 0.0)
		c = Hex(0.0, -1.0, 1.0)
		equal_hex("hex_round 1", Hex(5, -10, 5), hex_round(hex_lerp(Hex(0.0, 0.0, 0.0), Hex(10.0, -20.0, 10.0), 0.5)))
		equal_hex("hex_round 2", hex_round(a), hex_round(hex_lerp(a, b, 0.499)))
		equal_hex("hex_round 3", hex_round(b), hex_round(hex_lerp(a, b, 0.501)))
		equal_hex("hex_round 4", hex_round(a), hex_round(Hex(a.q * 0.4 + b.q * 0.3 + c.q * 0.3, a.r * 0.4 + b.r * 0.3 + c.r * 0.3, a.s * 0.4 + b.s * 0.3 + c.s * 0.3)))
		equal_hex("hex_round 5", hex_round(c), hex_round(Hex(a.q * 0.3 + b.q * 0.3 + c.q * 0.4, a.r * 0.3 + b.r * 0.3 + c.r * 0.4, a.s * 0.3 + b.s * 0.3 + c.s * 0.4)))

	func test_hex_linedraw():
		equal_hex_array("hex_linedraw", [Hex(0, 0, 0), Hex(0, -1, 1), Hex(0, -2, 2), Hex(1, -3, 2), Hex(1, -4, 3), Hex(1, -5, 4)], hex_linedraw(Hex(0, 0, 0), Hex(1, -5, 4)))

	func test_layout():
		h = Hex(3, 4, -7)
		flat = Layout(layout_flat, Point(10.0, 15.0), Point(35.0, 71.0))
		equal_hex("layout", h, hex_round(pixel_to_hex(flat, hex_to_pixel(flat, h))))
		pointy = Layout(layout_pointy, Point(10.0, 15.0), Point(35.0, 71.0))
		equal_hex("layout", h, hex_round(pixel_to_hex(pointy, hex_to_pixel(pointy, h))))

	func test_offset_roundtrip():
		a = Hex(3, 4, -7)
		b = OffsetCoord(1, -3)
		equal_hex("conversion_roundtrip even-q", a, qoffset_to_cube(EVEN, qoffset_from_cube(EVEN, a)))
		equal_offsetcoord("conversion_roundtrip even-q", b, qoffset_from_cube(EVEN, qoffset_to_cube(EVEN, b)))
		equal_hex("conversion_roundtrip odd-q", a, qoffset_to_cube(ODD, qoffset_from_cube(ODD, a)))
		equal_offsetcoord("conversion_roundtrip odd-q", b, qoffset_from_cube(ODD, qoffset_to_cube(ODD, b)))
		equal_hex("conversion_roundtrip even-r", a, roffset_to_cube(EVEN, roffset_from_cube(EVEN, a)))
		equal_offsetcoord("conversion_roundtrip even-r", b, roffset_from_cube(EVEN, roffset_to_cube(EVEN, b)))
		equal_hex("conversion_roundtrip odd-r", a, roffset_to_cube(ODD, roffset_from_cube(ODD, a)))
		equal_offsetcoord("conversion_roundtrip odd-r", b, roffset_from_cube(ODD, roffset_to_cube(ODD, b)))

	func test_offset_from_cube():
		equal_offsetcoord("offset_from_cube even-q", OffsetCoord(1, 3), qoffset_from_cube(EVEN, Hex(1, 2, -3)))
		equal_offsetcoord("offset_from_cube odd-q", OffsetCoord(1, 2), qoffset_from_cube(ODD, Hex(1, 2, -3)))

	func test_offset_to_cube():
		equal_hex("offset_to_cube even-", Hex(1, 2, -3), qoffset_to_cube(EVEN, OffsetCoord(1, 3)))
		equal_hex("offset_to_cube odd-q", Hex(1, 2, -3), qoffset_to_cube(ODD, OffsetCoord(1, 2)))

	func test_doubled_roundtrip():
		a = Hex(3, 4, -7)
		b = DoubledCoord(1, -3)
		equal_hex("conversion_roundtrip doubled-q", a, qdoubled_to_cube(qdoubled_from_cube(a)))
		equal_doubledcoord("conversion_roundtrip doubled-q", b, qdoubled_from_cube(qdoubled_to_cube(b)))
		equal_hex("conversion_roundtrip doubled-r", a, rdoubled_to_cube(rdoubled_from_cube(a)))
		equal_doubledcoord("conversion_roundtrip doubled-r", b, rdoubled_from_cube(rdoubled_to_cube(b)))

	func test_doubled_from_cube():
		equal_doubledcoord("doubled_from_cube doubled-q", DoubledCoord(1, 5), qdoubled_from_cube(Hex(1, 2, -3)))
		equal_doubledcoord("doubled_from_cube doubled-r", DoubledCoord(4, 2), rdoubled_from_cube(Hex(1, 2, -3)))

	func test_doubled_to_cube():
		equal_hex("doubled_to_cube doubled-q", Hex(1, 2, -3), qdoubled_to_cube(DoubledCoord(1, 5)))
		equal_hex("doubled_to_cube doubled-r", Hex(1, 2, -3), rdoubled_to_cube(DoubledCoord(4, 2)))

	func test_all():
		test_hex_arithmetic()
		test_hex_direction()
		test_hex_neighbor()
		test_hex_diagonal()
		test_hex_distance()
		test_hex_rotate_right()
		test_hex_rotate_left()
		test_hex_round()
		test_hex_linedraw()
		test_layout()
		test_offset_roundtrip()
		test_offset_from_cube()
		test_offset_to_cube()
		test_doubled_roundtrip()
		test_doubled_from_cube()
		test_doubled_to_cube()

