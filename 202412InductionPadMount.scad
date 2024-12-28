// created by IndiePandaaaaa|Lukas
// encoding: utf-8

use <Parts/Screw.scad>

THICKNESS = 2.5;
TOLERANCE = .15;
$fn = $preview? 25:125;

PAD_HEIGHT = 8;
PAD_DIAMETER = 89.8 + .1;

module pad_mount() {
  edges = 8;
  difference() {
    rotate([0, 0, 90 + 360/edges/2]) cylinder(d=PAD_DIAMETER + THICKNESS*2, h=PAD_HEIGHT + THICKNESS - TOLERANCE, $fn=edges);
    translate([0, 0, THICKNESS + TOLERANCE]) cylinder(d=PAD_DIAMETER, h=PAD_HEIGHT);

    for (i=[0:1]) {
      translate([-12 + 24*i, 25, THICKNESS]) screw(3.5, 12, true);
    }
  }
}

pad_mount();
