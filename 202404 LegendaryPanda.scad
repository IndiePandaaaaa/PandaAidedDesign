// created by IndiePandaaaaa
// encoding: utf-8

use <202312 CableCombs.scad>


module cable_combs() {
  module panda_comb(cables, combs = 0, sorter = 0, rows = 2, distance = .42, cable_od = 3.5) {
    translate([-comb_width(cables, rows, cable_od, distance) - 2, 17, 0]) rotate([0, 0, 0]) 
      angled_comb(180, 10, cables, rows, cable_od, distance);

    if (combs != 0) {
      for (i = [0:combs - 1]) {
        translate([(comb_width(cables, rows, cable_od, distance) + 2) * i + 2, 2, 0]) 
          comb(cables, rows, cable_od, distance);
      }
    }

    if (sorter != 0) {
      for (i = [0:sorter - 1]) {
        translate([2 + (comb_width(cables, rows, cable_od, 1) + 3 * 2 * 2 + 2) * i, comb_depth(rows, cable_od, 1) + 5, 0]) 
          threaded_comb(cables, rows, cable_od, 1);
      }
    }
  }

  panda_comb(24, 2, 2);
  translate([0, 35, 0]) panda_comb(12, 1, 3);
  translate([0, 70, 0]) panda_comb(8, 5, 7);
}


cable_combs();
