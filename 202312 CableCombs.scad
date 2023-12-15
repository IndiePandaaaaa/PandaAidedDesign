// created by IndiePandaaaaa|Lukas

TOLERANCE = .1;
THICKNESS = 2.5;
PRINT_SEPARATED = true;
$fn = 75;

CABLE_COUNT = 16;
CABLE_ROWS = 2;
CABLE_OD = 3.5;
CABLE_DISTANCE = .42;

CABLE_ANGLE = 180;
CABLE_RADIUS = 14;

function comb_width(cable_count, cable_rows, cable_od, cable_distance, outer_border = 1) = outer_border * 2 + (cable_count / cable_rows) * (cable_od + cable_distance) - cable_distance;

function comb_depth(cable_rows, cable_od, cable_distance, outer_border = 1) = outer_border * 2 + cable_rows * (cable_od + cable_distance) - cable_distance;

module comb(cable_count, cable_rows, cable_od, cable_distance = 1, thickness = 2, tolerance = .1) {
  outer_border = 1;
  width = comb_width(cable_count, cable_rows, cable_od, cable_distance, outer_border);
  depth = comb_depth(cable_rows, cable_od, cable_distance, outer_border);
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

module angled_comb(cable_angle, cable_radius, cable_count, cable_rows, cable_od, cable_distance, thickness = 2, outer_border = 1, tolerance = .1) {
  module border(cable_angle, cable_radius, width) {
    difference() {
      cylinder(d = cable_radius * 2 + width / 2, h = thickness);
      translate([0, 0, -thickness * 0.25]) cylinder(d = cable_radius * 2 - width / 2, h = thickness * 1.5);

      translate([0, 0, -thickness * 0.25]) {
        cubew = cable_radius + width / 2;
        translate([-cubew, 0, 0]) cube(cubew);
        if (cable_angle <= 90)
          translate([0, -cubew, 0]) cube(cubew);
        if (cable_angle <= 180)
          translate([-cubew, -cubew, 0]) cube(cubew);
      }
    }
  }

// todo: printing in parts to push fit them

  cylw = comb_depth(cable_rows, cable_od, cable_distance, outer_border);
  cyld = comb_width(cable_count, cable_rows, cable_od, cable_distance, outer_border);

  union() {
    rotate([0, -90, 0]) border(cable_angle, cable_radius, cylw);

    for (i = [0:cable_angle / 45]) {
      rotate([45 * i, 0, 0])
        translate([0, cable_radius - cylw / 2, -thickness / 2]) {
          comb(cable_count, cable_rows, cable_od, cable_distance, thickness);

          blockw = cylw / 2 - (PI / 2 / 100);
          rotate([0, 0, 90]) translate([blockw / 2, 0, 0]) cube([blockw, thickness, thickness]);
          rotate([0, 0, 90]) translate([blockw / 2, -cyld - thickness + 0.01, 0]) cube([blockw, thickness, thickness]);
        }
    }

    rotate([0, -90, 0]) translate([0, 0, -cyld - thickness + 0.01]) border(cable_angle, cable_radius, cylw);
  }
}

angled_comb(CABLE_ANGLE, CABLE_RADIUS, CABLE_COUNT, CABLE_ROWS, CABLE_OD, CABLE_DISTANCE, THICKNESS);

  translate([0, 35, 0]) comb(CABLE_COUNT, CABLE_ROWS, CABLE_OD, CABLE_DISTANCE, THICKNESS);
