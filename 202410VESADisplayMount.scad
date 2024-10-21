// created by IndiePandaaaaaa|Lukas
// encoding: utf-8

use <Parts/Screw.scad>
use <Functions/Fillet.scad>

TOLERANCE = .1;
THICKNESS = 3;
$fn = 75;

// M4 Screws
M4OD = 7.2;
M4HEADHEIGHT = 4.5;


VESA = 100;

function plate_thickness() = TOLERANCE + THICKNESS + M4HEADHEIGHT;
function plate_size() = VESA + M4OD * 2;

module monitor_base() {
  union() {
    difference() {
      cube([plate_size(), plate_size(), plate_thickness()]);
      fillet_rectangle(M4OD, plate_size(), plate_size(), plate_thickness());

      translate([plate_size() / 2, plate_size() / 2, -.1]) for (i = [0:3]) {
        rotate([0, 0, 90 * i]) translate([VESA / 2, VESA / 2, 0]) {
          cylinder(d = 4.2, h = (M4HEADHEIGHT + THICKNESS + TOLERANCE) * 1.5);
          cylinder(d = M4OD + TOLERANCE, h = M4HEADHEIGHT + TOLERANCE);
        }
      }
    }
  }
}

module wall_base(for_cutout = false) {
  add_size = for_cutout ? .4 : 0;
  union() {
    translate([plate_size() / 4, plate_size() / 6, plate_thickness() + add_size / 2]) {
      rotate([-90, 0, 0]) linear_extrude(VESA / 3 * 2) {
        polygon([
          [-add_size, -add_size],
          [plate_size() / 2 + add_size, -add_size],
          [plate_size() / 2 - plate_thickness() - add_size, plate_thickness() + add_size],
          [plate_thickness() + add_size, plate_thickness() + add_size],
        ]);
      }
    }
    intersection() {
      translate([plate_size() / 2, plate_size() / 2.4, -add_size / 2]) rotate([0, 0, 225]) cube([plate_size(), plate_size(), plate_thickness() + add_size]);
      translate([0, -add_size / 2, -add_size / 2]) cube([plate_size() * 1.5, plate_size() * 1.5, plate_thickness() + add_size]);
    }
  }
}

// todo: add thickness to wall part, to acomodate tolerance issues.

module monitor_part() {
  difference() {
    monitor_base();
    wall_base(true);
  }
}

translate([0, 0, 0]) monitor_part();
color("#505050") wall_base();
