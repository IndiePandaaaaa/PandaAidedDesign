// created by IndiePandaaaaa|Lukas

TOLERANCE = .1;
$fn = 75;

module unterlagsscheibe(id, od, thickness, tolerance = .1, fn = 75) {
  $fn = fn;

  difference() {
    cylinder(d = od - tolerance, h = thickness, center = true);
    cylinder(d = id + tolerance, h = thickness, center = true);
  }
}

unterlagsscheibe(3.8, 12, 2.7);
