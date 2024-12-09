// created by IndiePandaaaaa | Lukas

use <Parts/Screw.scad>

THICKNESS = 2.5;
TOLERANCE_TIGHT = 0.1;
TOLERANCE_LOOSE = 0.25;
CHAMFER = 1;
SCREW_OD = 3.5;
$fn = 75;

AXIS_OD = 6;
AXIS_LENGTH = 30;
WHEEL_OD = 21;
WHEEL_ID = AXIS_OD + TOLERANCE_TIGHT;
WHEEL_WIDTH = AXIS_LENGTH - (THICKNESS * 2);

module wheel(id, od, width, chamfer = 1.5, thickness = 2.5) {
  translate([-width / 2, 0, 0]) rotate([0, 90, 0])
    difference() {
      rotate_extrude() {
        polygon([
            [id / 2, 0],
            [od / 2 - chamfer, 0],
            [od / 2, chamfer],
            [od / 2, width - chamfer],
            [od / 2 - chamfer, width],
            [id / 2, width],
          ]);
      }

      for (i = [0:6]) {
        rotate([0, 0, 60 * i]) translate([0, id + chamfer, -width / 2]) rotate([0, 0, 30])
          cylinder(h = width * 2, d = (od - chamfer - thickness - id) / 2, $fn = 3);
      }
    }
}

module bracket(id, od, wheel_width, screw_od, thickness, tolerance = 0.5) {
  height = od * 1.25;
  bracket_depth = wheel_width + screw_od * 2;
  bracket_width = wheel_width + thickness * 2 + tolerance;
  axis_height = height - id * 1.25;

  translate([-bracket_width / 2, -bracket_depth / 2, axis_height])
    rotate([-90, 0, 0]) {
      difference() {
        linear_extrude(bracket_depth) {
          polygon([
              [0, 0],
              [0, height],
              [thickness, height],
              [thickness, thickness],
              [wheel_width + thickness + tolerance, thickness],
              [wheel_width + thickness + tolerance, height],
              [bracket_width, height],
              [bracket_width, 0],
            ]);
        }
        translate([-thickness, axis_height, bracket_depth / 2])
          rotate([0, 90, 0])
            cylinder(h = wheel_width + THICKNESS * 4, d = id + tolerance);

        translate([bracket_width / 2, thickness, screw_od * 1.5])
          rotate([-90, 0, 0]) screw(screw_od, 12, true);
        translate([bracket_width / 2, thickness, bracket_depth - screw_od * 1.5])
          rotate([-90, 0, 0]) screw(screw_od, 12, true);

        translate([0, height * 2 / 3, 0]) rotate([-45, 0, 0]) cube(bracket_width);
        translate([0, height * 2 / 3, bracket_depth]) rotate([-45, 0, 0]) cube(bracket_width);
      }
    }
}

translate([0, 0, -WHEEL_WIDTH]) wheel(WHEEL_ID, WHEEL_OD, WHEEL_WIDTH, CHAMFER, THICKNESS);
bracket(WHEEL_ID, WHEEL_OD, WHEEL_WIDTH, SCREW_OD, THICKNESS);










