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
    union() {
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

      blockw = width / 2 - (PI / 2 / 100);
      translate([0, cable_radius - width / 4, 0]) rotate([0, 0, 90]) cube([blockw, thickness / 2, thickness]);
      rotate([0, 0, 90 - cable_angle]) translate([cable_radius - width / 4, -thickness / 2, 0]) cube([blockw, thickness / 2, thickness]);
    }
  }
  module segments(cable_angle, cable_radius, width, cable_count, cable_rows, cable_od, cable_distance, thickness, cutout = false, tolerance = .1, angle_steps = 45) {
    thickness_cutout = cutout == false ? thickness : thickness + tolerance;
    cwidth = comb_width(cable_count, cable_rows, cable_od, cable_distance, outer_border);
    for (i = [0:cable_angle / angle_steps]) {
      rotate([angle_steps * i, 0, 0])
        translate([0, cable_radius - width / 2, -thickness_cutout / 2]) {
          comb(cable_count, cable_rows, cable_od, cable_distance, thickness_cutout);

          blockw = cutout == false ? width / 2 - (PI / 2 / 100) : width;
          rotate([0, 0, 90]) {
            translate([cutout == false ? blockw / 2 : 0, 0, 0]) cube([blockw, thickness_cutout / 2, thickness_cutout]);
            translate([cutout == false ? blockw / 2 : 0, -cwidth - thickness_cutout / 2 + 0.01, 0]) cube([blockw, thickness_cutout / 2, thickness_cutout]);
          }
        }
    }
  }

  cylw = comb_depth(cable_rows, cable_od, cable_distance, outer_border);
  cyld = comb_width(cable_count, cable_rows, cable_od, cable_distance, outer_border);

  difference() {
    rotate([0, -90, 0]) { 
      border(cable_angle, cable_radius, cylw);
      translate([0, 0, -cyld - thickness + 0.01]) border(cable_angle, cable_radius, cylw);
    }
    segments(cable_angle, cable_radius, cylw, cable_count, cable_rows, cable_od, cable_distance, thickness, true, .15, 45);
  }
  segments(cable_angle, cable_radius, cylw, cable_count, cable_rows, cable_od, cable_distance, thickness, false, .1, 45);
}

angled_comb(CABLE_ANGLE, CABLE_RADIUS, CABLE_COUNT, CABLE_ROWS, CABLE_OD, CABLE_DISTANCE, THICKNESS);

translate([0, 35, 0]) comb(CABLE_COUNT, CABLE_ROWS, CABLE_OD, CABLE_DISTANCE, THICKNESS);
