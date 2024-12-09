// created by IndiePandaaaaa|Lukas

use <Variables/Threading.scad>

$fn = 70;

SIZE = 16;

module core_holes(size, diameter) {
  rotate([0, 0, 0]) cylinder(d = diameter, h = SIZE * 1.25, center = true);
  rotate([90, 0, 0]) cylinder(d = diameter, h = SIZE * 1.25, center = true);
  rotate([0, 90, 0]) cylinder(d = diameter, h = SIZE * 1.25, center = true);
}

module cube_fixture(size, hole_to_size_factor = 2) {
  for (i = [0:4]) {
    translate([size / 2 + size * 1.5 * i, size / 2, size / 2]) {
      if (i == 0 && size >= core_hole_M3() * hole_to_size_factor) {
        difference() {
          translate([-size / 2, -size / 2, -size / 2]) cube(size);
          core_holes(size, core_hole_M3());
        }
        linear_extrude(1)
          translate([size / 4, size, -size / 2]) rotate([0, 0, 90]) text("M3", size = size / 2);
      } else if (i == 1 && size >= core_hole_M4() * hole_to_size_factor) {
        difference() {
          translate([-size / 2, -size / 2, -size / 2]) cube(size);
          core_holes(size, core_hole_M4());
        }
        linear_extrude(1)
          translate([size / 4, size, -size / 2]) rotate([0, 0, 90]) text("M4", size = size / 2);
      } else if (i == 2 && size >= core_hole_M5() * hole_to_size_factor) {
        difference() {
          translate([-size / 2, -size / 2, -size / 2]) cube(size);
          core_holes(size, core_hole_M5());
        }
        linear_extrude(1)
          translate([size / 4, size, -size / 2]) rotate([0, 0, 90]) text("M5", size = size / 2);
      } else if (i == 3 && size >= core_hole_UNC14() * hole_to_size_factor) {
        difference() {
          translate([-size / 2, -size / 2, -size / 2]) cube(size);
          core_holes(size, core_hole_UNC14());
        }
        linear_extrude(1)
          translate([size / 4, size, -size / 2]) rotate([0, 0, 90]) text("UNC1/4\"", size = size / 2);
      } else if (i == 4 && size >= core_hole_UNC38() * hole_to_size_factor) {
        difference() {
          translate([-size / 2, -size / 2, -size / 2]) cube(size);
          core_holes(size, core_hole_UNC38());
        }
        linear_extrude(1)
          translate([size / 4, size, -size / 2]) rotate([0, 0, 90]) text("UNC3/8\"", size = size / 2);
      }
    }
  }
}

cube_fixture(SIZE);