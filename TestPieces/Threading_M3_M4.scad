// created by IndiePandaaaaa | Lukas

use <../Variables/Threading.scad>

difference() {
  cube([17, 24, 10]);
  for (i = [0:2]) {
    translate([5, 5 + 7 * i, -2]) {
      cylinder(15, d = core_hole_M4(), $fs = 0.1);
      translate([7, 0, 0])
        cylinder(15, d = core_hole_M3(), $fs = 0.1);
    }
  }
}