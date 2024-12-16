// created by IndiePandaaaaa|Lukas
// encoding: utf-8

use <Parts/Screw.scad>

$fn = $preview ? 25 : 125;

SCREWOD = 3.5;

module CAPI_mount() {
  thickness = 3;
  difference() {
    linear_extrude(thickness) {
      polygon([
        [0, 0],
        [15, 0],
        [15, 40],
        [(92 - 41)/2, 55],
        [(92 + 41)/2, 55],
        [92 - 15, 40],
        [92 - 15, 0],
        [92, 0],
        [92, 55],
        [(92 + 41)/2, 80],
        [(92 - 41)/2, 80],
        [0, 55],
      ]);
    }

    translate([46, 80 - 10, -.1]) cylinder(d=2.5, h=thickness + .2);
    
    for (i=[0:1]) {
      translate([46 - (42 - SCREWOD*4)/2 + (42 + SCREWOD*4)/2*i, 60, thickness]) screw(SCREWOD, 12, true);
    }
  }
}

CAPI_mount();
