// created by IndiePandaaaaa|Lukas
// encoding: utf-8

use <Parts/Screw.scad>

SCREW_OD = 3.5;
WIDTH = 42;

module support_plate(width, screw_od, screw_count=2, thickness=2.2) {
  difference() {
    cube([width, 4*screw_od, thickness], center=true);
    for (i=[0:screw_count-1]) {
      mirror([i, 0, 0]) translate([(-width/2 + screw_od*2), 0, thickness]) screw(screw_od, 12, true);
    }
  }
}

support_plate(WIDTH, SCREW_OD);
