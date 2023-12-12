// created by IndiePandaaaaa|Lukas

TOLERANCE = .1;
THICKNESS = 2.5;
PRINT_SEPARATED = true;
$fn = 75;

CABLE_COUNT = 24;
CABLE_ROWS = 2;
CABLE_OD = 3;
CABLE_DISTANCE = .42;

CABLE_ANGLE = 90;

module comb(cable_count, cable_rows, cable_od, cable_distance = 1, thickness = 2, tolerance = .1) {
  outer_border = 1;
  width = outer_border * 2 + (cable_count / cable_rows) * (cable_od + cable_distance) - cable_distance;
  depth = outer_border * 2 + cable_rows * (cable_od + cable_distance) - cable_distance;
  chamfer = cable_od / 2;

  difference() {
    linear_extrude(thickness) {
      polygon([
        [chamfer, 0],
        [width - chamfer, 0],
        [width, chamfer],
        [width, depth - chamfer],
        [width - chamfer, depth],
        [chamfer, depth],
        [0, depth - chamfer],
        [0, chamfer],
      ]);
    }

    for (y = [0:cable_rows - 1]) {
      for (x = [0:cable_count / cable_rows - 1]) {
        translate([outer_border + cable_od / 2 + (cable_distance + cable_od) * x, 
                  outer_border + cable_od / 2 + (cable_distance + cable_od) * y, 
                  -thickness * 0.25])
          cylinder(d=cable_od + tolerance, h=thickness * 2);
      }
    }

    cutout = cable_distance < 1 ? 1 : 0;
    translate([outer_border + cable_od / 2, outer_border + cable_od / 2, -thickness * 0.25])
      cube([width - outer_border * 2 - cable_od * cutout, depth - outer_border * 2 - cable_od * cutout, thickness * 1.5 * cutout]);
  }
} 

comb(CABLE_COUNT, CABLE_ROWS, CABLE_OD, CABLE_DISTANCE, THICKNESS);
