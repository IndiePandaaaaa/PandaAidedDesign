// created by IndiePandaaaaa
// encoding: utf-8

use <202312 CableCombs.scad>
use <Variables/Threading.scad>
use <Functions/Fillet.scad>
use <Logo/logo.scad>


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

module psu_brackets(thickness = 1.5) {
  module psu_bracket(thickness = 1.5) {
    // Seasonic Prime-Connect 80PLUS 750W
    height = 22.5;
    width = 64;
    depth = 7;
    thread_socket_width = 10;

    difference() {
      cube([width + thread_socket_width * 2, depth, height + thickness]);

      translate([thread_socket_width, -.1, -.1]) cube([width, depth + .2, height + .1]);
      translate([thread_socket_width / 2, depth / 2, -.1]) {
        cylinder(d = core_hole_M3(), h = height + thickness + .2);
        translate([width + thread_socket_width, 0, 0]) cylinder(d = core_hole_M3(), h = height + thickness + .2);
      }
    }
  }

  psu_bracket(thickness);
  translate([0, 10, 0]) psu_bracket(thickness);
}

module psu_shroud(thickness = 2, tolerance = .25) {
  // case: Kolink Citadel Mesh
  depth_possible = 10.5;
  depth_minimal = 4.6;
  height = 66.5 - tolerance;
  width = 116.7 - tolerance;
  radius = 10;
  metal_thickness = 1;
  additional_size = 7;
  holes = [ 
    [0, 0], 
    [width + additional_size + metal_thickness * 2, 0], 
    [width + additional_size + metal_thickness * 2, height + additional_size + metal_thickness * 2], 
    [0, height + additional_size + metal_thickness * 2] 
  ];

  rotate([90, 0, 0]) {
    difference() {
      union() {
        additional = (additional_size + metal_thickness) * 2;
        translate([additional / 2, additional / 2, thickness]) difference() {
          cube([width, height, depth_minimal]);
          fillet_rectangle(radius, width, height, depth_minimal);
        }
        
        cube([width + additional, height + additional, thickness]);
        
        translate([0, 0, thickness]) difference() {
          cube([width + additional, height + additional, depth_minimal - .2]);
          translate([additional_size, additional_size, -.1]) 
            cube([width + metal_thickness * 2, height + metal_thickness * 2, depth_minimal]);
        }

        position = [width, height - 10];
        translate([additional / 2 + (width - position[0]) / 2, additional / 2 + (height - position[1]) / 2, thickness + depth_minimal]) 
          color("black") generate_logo(position[0], position[1], 2);
      }

      for (i = [0:3]) {
        translate([additional_size / 2 + holes[i][0], additional_size / 2 + holes[i][1], -.1]) 
          cylinder(d = core_hole_M3(), h = thickness + depth_minimal);
      }
    }
  }
}

//cable_combs();
translate([0, 30, 0]) pcie_riser_socket();
translate([0, 70, 0]) psu_brackets();
translate([0, 0, 0]) psu_shroud();
