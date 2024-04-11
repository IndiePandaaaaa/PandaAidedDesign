// created by IndiePandaaaaa|Lukas

use <Variables/Threading.scad>

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

function comb_chamfer(cable_od) = cable_od / 2;

module comb(cable_count, cable_rows, cable_od, cable_distance = 1, thickness = 2, with_chamfer = true, tolerance = .1) {
  outer_border = 1;
  width = comb_width(cable_count, cable_rows, cable_od, cable_distance, outer_border);
  depth = comb_depth(cable_rows, cable_od, cable_distance, outer_border);
  chamfer = with_chamfer ? comb_chamfer(cable_od) : 0;

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

module threaded_comb(cable_count, cable_rows, cable_od, cable_distance = 1, screw_od = 3, tolerance = .1) {
  module mounting_cube(width, thickness, screw_od) {
    difference() {
      cube([thickness, width, thickness]);
      translate([thickness / 2, width / 2, -.1])
        cylinder(d = core_hole(screw_od), h = thickness + .2);
      translate([thickness / 2, -.1, thickness / 2]) rotate([-90, 0, 0])
        cylinder(d = core_hole(screw_od), h = width + .2);
    }
  }

  thickness = screw_od * 2;
  mount_cube_width = comb_depth(cable_rows, cable_od, cable_distance);

  union() {
    mounting_cube(mount_cube_width, thickness, screw_od);
    translate([thickness, 0, 0]) {
      comb(cable_count, cable_rows, cable_od, cable_distance, thickness, with_chamfer = false);
      translate([comb_width(cable_count, cable_rows, cable_od, cable_distance), 0, 0])
        mounting_cube(mount_cube_width, thickness, screw_od);
    }
  }
}

module angled_comb(cable_angle, cable_radius, cable_count, cable_rows, cable_od, cable_distance, thickness = 2, outer_border = 1, tolerance = .1) {

  module border_inside(cable_angle, cable_radius, comb_width, cable_od, comb_depth, thickness = 2, tolerance = .1) {
    cylinder_od = cable_radius * 2 - comb_depth / 2 - comb_chamfer(cable_od) * 2 + tolerance;
    cylinder_id = cylinder_od - thickness * 3;
    
    difference() {
      cylinder(d = cylinder_od, h = comb_width - comb_chamfer(cable_od) * 2);

      if (cable_radius > 12)
        translate([0, 0, -0.05]) cylinder(d = cylinder_id, h = comb_width * 2);

      translate([thickness / 2, -thickness / 2, -thickness * .25]) {
        cubew = comb_width;

        cube(cubew);
        if (cable_angle <=  90) translate([.1, 0, 0]) rotate([0, 0, 180]) cube(cubew);
        if (cable_angle <= 180) translate([0, .1, 0]) rotate([0, 0, 270]) cube(cubew);
      }
    }
  }

  module segments(cable_angle, cable_radius, width, cable_count, cable_rows, cable_od, cable_distance, thickness, cutout = false, tolerance = .1, angle_steps = 45) {
    thickness_cutout = cutout == false ? thickness : thickness + tolerance;
    cwidth = comb_width(cable_count, cable_rows, cable_od, cable_distance, outer_border);
    for (i = [0:cable_angle / angle_steps]) {
      rotate([angle_steps * i, 0, 0])
        translate([0, cable_radius - width / 2, -thickness_cutout / 2]) {
          comb(cable_count, cable_rows, cable_od, cable_distance, thickness_cutout);

          blockw = cutout == false ? 0 : 1;
          translate([comb_chamfer(cable_od) - tolerance * blockw, -comb_chamfer(cable_od) / 2 - blockw * tolerance / 2, 0])
            cube([cwidth - comb_chamfer(cable_od) * 2 + 2 * tolerance * blockw, thickness_cutout / 2, thickness_cutout]);
        }
    }
  }

  cylw = comb_depth(cable_rows, cable_od, cable_distance, outer_border);
  cyld = comb_width(cable_count, cable_rows, cable_od, cable_distance, outer_border);

  translate([0, 0, thickness / 2]) union() {
    difference() {
      rotate([0, 90, 0]) translate([0, 0, comb_chamfer(cable_od)]) border_inside(cable_angle, cable_radius, cyld, cable_od, cylw, thickness, tolerance);
      segments(cable_angle, cable_radius, cylw, cable_count, cable_rows, cable_od, cable_distance, thickness, true, .15, 45);
    }
    segments(cable_angle, cable_radius, cylw, cable_count, cable_rows, cable_od, cable_distance, thickness, false, .1, 45);
  }
}

angled_comb(CABLE_ANGLE, CABLE_RADIUS, CABLE_COUNT, CABLE_ROWS, CABLE_OD, CABLE_DISTANCE, THICKNESS);

translate([0, 25, 0]) comb(CABLE_COUNT, CABLE_ROWS, CABLE_OD, CABLE_DISTANCE, THICKNESS);

