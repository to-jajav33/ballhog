class Hex:
	
	var _q
	var _r
	var _s
	
	# These should be static, or const, or use getset ? idk
	var hex_directions = [_init(1, 0, -1), _init(1, -1, 0), _init(0, -1, 1), _init(-1, 0, 1), _init(-1, 1, 0), _init(0, 1, -1)]
	var hex_diagonals = [_init(2, -1, -1), _init(1, -2, 1), _init(-1, -1, 2), _init(-2, 1, 1), _init(-1, 2, -1), _init(1, 1, -2)]

	func _init(q, r, s):
		assert(int(q + r + s) == 0)
		return _Hex(q, r, s)

	func hex_add(a, b):
		return Hex(a.q + b.q, a.r + b.r, a.s + b.s)

	func hex_subtract(a, b):
		return Hex(a.q - b.q, a.r - b.r, a.s - b.s)

	func hex_scale(a, k):
		return Hex(a.q * k, a.r * k, a.s * k)

	func hex_rotate_left(a):
		return Hex(-a.s, -a.q, -a.r)

	func hex_rotate_right(a):
		return Hex(-a.r, -a.s, -a.q)
	
	func hex_direction(direction):
		return hex_directions[direction]

	func hex_neighbor(hex, direction):
		return hex_add(hex, hex_direction(direction))

	func hex_diagonal_neighbor(hex, direction):
		return hex_add(hex, hex_diagonals[direction])

	func hex_length(hex):
		return (abs(hex.q) + abs(hex.r) + abs(hex.s)) / 2

	func hex_distance(a, b):
		return hex_length(hex_subtract(a, b))

	func hex_round(h):
		qi = int(round(h.q))
		ri = int(round(h.r))
		si = int(round(h.s))
		q_diff = abs(qi - h.q)
		r_diff = abs(ri - h.r)
		s_diff = abs(si - h.s)
		if q_diff > r_diff and q_diff > s_diff:
			qi = -ri - si
		else:
			if r_diff > s_diff:
				ri = -qi - si
			else:
				si = -qi - ri
		return Hex(qi, ri, si)

	func hex_lerp(a, b, t):
		return Hex(a.q * (1.0 - t) + b.q * t, a.r * (1.0 - t) + b.r * t, a.s * (1.0 - t) + b.s * t)

	func hex_linedraw(a, b):
		N = hex_distance(a, b)
		a_nudge = Hex(a.q + 1e-06, a.r + 1e-06, a.s - 2e-06)
		b_nudge = Hex(b.q + 1e-06, b.r + 1e-06, b.s - 2e-06)
		results = []
		step = 1.0 / max(N, 1)
		for i in range(0, N + 1):
			results.append(hex_round(hex_lerp(a_nudge, b_nudge, step * i)))
		return results



# Tests


# the typescript code for orientation and layout:
#struct Orientation
#{
#    public Orientation(double f0, double f1, double f2, double f3, double b0, double b1, double b2, double b3, double start_angle)
#    {
#        this.f0 = f0;
#        this.f1 = f1;
#        this.f2 = f2;
#        this.f3 = f3;
#        this.b0 = b0;
#        this.b1 = b1;
#        this.b2 = b2;
#        this.b3 = b3;
#        this.start_angle = start_angle;
#    }
#    public readonly double f0;
#    public readonly double f1;
#    public readonly double f2;
#    public readonly double f3;
#    public readonly double b0;
#    public readonly double b1;
#    public readonly double b2;
#    public readonly double b3;
#    public readonly double start_angle;
#}
#
#struct Layout
#{
#    public Layout(Orientation orientation, Point size, Point origin)
#    {
#        this.orientation = orientation;
#        this.size = size;
#        this.origin = origin;
#    }
#    public readonly Orientation orientation;
#    public readonly Point size;
#    public readonly Point origin;
#    static public Orientation pointy = new Orientation(Math.Sqrt(3.0), Math.Sqrt(3.0) / 2.0, 0.0, 3.0 / 2.0, Math.Sqrt(3.0) / 3.0, -1.0 / 3.0, 0.0, 2.0 / 3.0, 0.5);
#    static public Orientation flat = new Orientation(3.0 / 2.0, 0.0, Math.Sqrt(3.0) / 2.0, Math.Sqrt(3.0), 2.0 / 3.0, 0.0, -1.0 / 3.0, Math.Sqrt(3.0) / 3.0, 0.0);
#
#    public Point HexToPixel(Hex h)
#    {
#        Orientation M = orientation;
#        double x = (M.f0 * h.q + M.f1 * h.r) * size.x;
#        double y = (M.f2 * h.q + M.f3 * h.r) * size.y;
#        return new Point(x + origin.x, y + origin.y);
#    }
#
#
#    public FractionalHex PixelToHex(Point p)
#    {
#        Orientation M = orientation;
#        Point pt = new Point((p.x - origin.x) / size.x, (p.y - origin.y) / size.y);
#        double q = M.b0 * pt.x + M.b1 * pt.y;
#        double r = M.b2 * pt.x + M.b3 * pt.y;
#        return new FractionalHex(q, r, -q - r);
#    }
#
#
#    public Point HexCornerOffset(int corner)
#    {
#        Orientation M = orientation;
#        double angle = 2.0 * Math.PI * (M.start_angle - corner) / 6.0;
#        return new Point(size.x * Math.Cos(angle), size.y * Math.Sin(angle));
#    }
#
#
#    public List<Point> PolygonCorners(Hex h)
#    {
#        List<Point> corners = new List<Point>{};
#        Point center = HexToPixel(h);
#        for (int i = 0; i < 6; i++)
#        {
#            Point offset = HexCornerOffset(i);
#            corners.Add(new Point(center.x + offset.x, center.y + offset.y));
#        }
#        return corners;
#    }
#
#}
