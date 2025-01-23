// created by IndiePandaaaaa|Lukas
// encoding: utf-8

use <Parts/Screw.scad>

SCREW_OD = 3.5;
WIDTH = 40;

module support_plate(width, screw_od, screw_count=2, thickness=2.5) {
  translate([screw_od*2, 0, 0]) difference() {
    translate([-screw_od*2, -screw_od*2, 0]) cube([width, 4*screw_od, thickness]);
    for (i=[0:screw_count - 1]) {
      translate([(screw_count==1? (width - screw_od*4)/2:0) + (width - screw_od*2*screw_count) / screw_count * i, 0, thickness]) screw(screw_od, 12, true);
    }
  }
}

for (i=[1:4]) {
  translate([0, -50 + 20*i, 0]) support_plate(WIDTH, SCREW_OD, screw_count=i);
}
