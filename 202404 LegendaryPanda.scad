// created by IndiePandaaaaa
// encoding: utf-8

use <202312 CableCombs.scad>
use <Variables/Threading.scad>


$fn = 75;

module cable_combs() {
  module panda_comb(cables, combs = 0, sorter = 0, rows = 2, distance = .42, cable_od = 3.5) {
    translate([-comb_width(cables, rows, cable_od, distance) - 2, 17, 0]) rotate([0, 0, 0]) 
      angled_comb(180, 12, cables, rows, cable_od, distance);

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

module pcie_riser_socket(thickness = 3) {
  // Kolink Citadel Mesh Riser socket for 90 degree CoolerMaster Riser V2
  case_hole_distance = 100;
  case_hole_id = 3.5;
  case_hole_od = 7.5;
  case_hole_height = 2;
  case_riser_offset_front = 15.8;
  case_riser_offset_left = 2.8;
  riser_height = 23;
  riser_width = 127;
  riser_depth = 14;
  riser_pcb_height = 1.7 - .2;
  riser_hole_distance = 117.6;
  riser_hole_front_distance = 5.8;

  difference() {
    union() {
      cube([riser_width, riser_depth + case_riser_offset_front, thickness]);
      translate([0, case_riser_offset_front, 0]) cube([riser_width, riser_depth, riser_height - riser_pcb_height]);
    }
    translate([(riser_width - riser_hole_distance) / 2, riser_hole_front_distance, -.1]) {
      translate([case_riser_offset_left, 0, 0]) {
        cylinder(d = case_hole_id, h = thickness + .2);
        translate([0, 0, case_hole_height]) cylinder(d = case_hole_od, h = thickness);

        translate([case_hole_distance, 0, 0]) {
          cylinder(d = case_hole_id, h = thickness + .2);
          translate([0, 0, case_hole_height]) cylinder(d = case_hole_od, h = thickness);
        }
      }
      translate([0, case_riser_offset_front, 0]) {
        cylinder(d = core_hole_M3(), h = riser_height);
        translate([riser_hole_distance, 0, 0]) cylinder(d = core_hole_M3(), h = riser_height);
      }
    }
  }
}

//cable_combs();
pcie_riser_socket();
