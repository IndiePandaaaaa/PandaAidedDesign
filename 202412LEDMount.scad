// created by IndiePandaaaaa|Lukas
// encoding: utf-8

use <Parts/Screw.scad>
use <202306lBracket.scad>

SCREWOD = 3.5;

module under_cabinet_light() { // casalux
  thickness = 2.5;
  chamfer = .5;

  translate([15 + thickness + 1 + 1.5, 0, 0]) union() {
    for (i=[0:1]) mirror([i, 0, 0]) translate([-15, 0, 0]) difference() {
      union() {
        mirror([1, 0, 0]) linear_extrude(5) {
          polygon([
            [0, 0],
            [thickness, 0],
            [thickness, SCREWOD*4 + 5],
            [thickness + 1.4, SCREWOD*4 + 5],
            [thickness + 1.4, SCREWOD*4],
            [thickness + 1.4 + 1, SCREWOD*4],
            [thickness + 1.4 + 1, SCREWOD*4 + 5 + 1.5],
            [0, SCREWOD*4 + 5 + 1.5],
          ]);
        }
        cube([SCREWOD*4, SCREWOD*4, thickness]);
      }
      translate([SCREWOD*2, SCREWOD*2, thickness]) screw(SCREWOD, 12, true);
    }
    translate([25, 0, 0]) LBracket(2, 42);
  }
}

under_cabinet_light();
