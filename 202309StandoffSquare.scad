// created by IndiePandaaaaa|Lukas

use <Parts/Screw.scad>

SCREW_OD = 3.5;
SIZE = 42;
HEIGHT = 2.2;

difference() {
  cube([42, 42, 2.2]);
  translate([SIZE / 2, SIZE / 2, HEIGHT]) screw(SCREW_OD, 12, true);
}