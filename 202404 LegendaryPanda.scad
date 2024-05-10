// created by IndiePandaaaaa
// encoding: utf-8

use <202312 CableCombs.scad>
use <202312 DDC_Standoff.scad>
use <202312 KolinkCitadelMesh_Accessories.scad>
use <Variables/Threading.scad>
use <Functions/Fillet.scad>
use <Logo/logo.scad>


$fn = 75;

module cable_combs() {
  module panda_comb(cables, combs = 0, sorter = 0, angled = 0, rows = 2, distance = .42, cable_od = 3.5) {
    if (angled != 0) {
      for (i = [0:angled - 1]) {
        translate([-comb_width(cables, rows, cable_od, distance) - 2, 17, 0]) rotate([0, 0, 0]) 
          angled_comb(180, 12, cables, rows, cable_od, distance);
      }
    }

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

  module angled_bracket(height, times = 1, rows = 2, cable_od = 3.5, tolerance = .1) {
    screw_od = 3;
    mounting_thickness = 2;
    width = screw_od * 4 + mounting_thickness + screw_od * 2 + tolerance;
    depth = screw_od * 2;

    for (i = [0:times - 1]) {
      translate([width * 1.2 * i, 0, 0]) difference() {
        union() {
          cube([width, depth, height]);
          translate([screw_od * 2, 0, 0])
            cube([mounting_thickness, depth, height + comb_depth(rows, cable_od, 1) + tolerance]);
        }

        translate([screw_od, screw_od, -.1]) {
          cylinder(d = core_hole_M3(), h = height + comb_depth(rows, cable_od, 1) * 2);
          translate([width - screw_od * 2, 0, 0])
            cylinder(d = core_hole_M3(), h = height + comb_depth(rows, cable_od, 1) * 2);
        }

        translate([screw_od, screw_od, height + comb_depth(rows, cable_od, 1) / 2 + tolerance])
          rotate([0, 90, 0]) cylinder(d = 3.2, h = height);
      }
    }
  }

  module threaded_offset_mount(cables, times = 1, rows = 2, cable_od = 3.5, distance = 1) {
    for (i = [0:times-1]) {
      translate([(6 * 2 + comb_width(cables, rows, cable_od, distance)) * 1.1 * i, 0, 0])
        threaded_comb(cables, rows, cable_od, distance, offset_mounting = true);
    }
  }

  // angled combs will not work due to tolerances for this build
  translate([0,   0, 0]) panda_comb(24, 2, 2, 0);
  translate([0,  30, 0]) panda_comb(12, 2, 3, 0);
  translate([0,  60, 0]) panda_comb(8, 5, 7, 0);

  translate([0,  90, 0]) angled_bracket(7, 3);

  //translate([0, 110, 0]) threaded_offset_mount(12, 2);
  translate([0, 130, 0]) threaded_offset_mount(5, 2, 1);

  translate([0, 140, 0]) panda_comb(5, 8, 0, 0, 1);
}

module ddc_standoff_plate() {
  rotate([90, 0, 0]) ddc_standoff(plate_height = 13.5);
}

module case_feet_citadel_mesh(diameter = 40, height = 15) {
  for (i = [0:3]) 
    translate([0, 0, 20 * i]) casefoot(height, diameter);
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

module ssd_cover(thickness = 2, tolerance = .1) {
  width = 100;
  height = 69.8;
  radius = 5;

  rotate([90, 0, 0]) union() {
    difference() {
      cube([width, height, thickness]);
      fillet_rectangle(radius, width, height, thickness);
    }
    position = [ width, height - 15 ];
    translate([(width - position[0]) / 2, (height - position[1]) / 2, thickness]) 
      color("black") generate_logo(position[0], position[1], thickness);
  }
}

module mainboard_tray_cover(thickness = 2, tolerance = .15) {
  width = 83;
  height = 215;

  // x, y, width, height
  cutout_sata = [ 0, 105, 9, 9 ];
  cutout_atx24 = [ 40, 35, comb_depth(2, 3.5, 1), comb_width(24, 2, 3.5, 1) ];

  rotate([-90, 0, 180]) translate([-width, -height, 0]) union() {
    difference() {
      cube([width, height, thickness]);

      translate([cutout_sata[0] - .1, cutout_sata[1], -.1]) 
        cube([cutout_sata[2] - .1, cutout_sata[3], thickness + .2]);

      translate([cutout_atx24[0] + .1, cutout_atx24[1] + .1, -.1])
        cube([cutout_atx24[2] - .2, cutout_atx24[3] - .2, thickness + .2]);

      translate([cutout_atx24[0] + cutout_atx24[2] / 2, cutout_atx24[1] - core_hole_M3() - .5, -.1]) {
        cylinder(d = 3.2, h = thickness + .2);
        translate([0, comb_mounting_distance(24, 2, 3.5), 0])
          cylinder(d = 3.2, h = thickness + .2);
      }
    }
    translate([cutout_atx24[0] + cutout_atx24[2], cutout_atx24[1], 0]) rotate([0, 0, 90])
      comb(24, 2, 3.5, with_chamfer = false);
  }
}

module matrix_mounting(thickness = 4, tolerance = .1) {
  width = 40;
  border = 2;
  cutout = 9.5;
  mounting = 7;
  threading = [ [0, 0], [width + mounting, 0], [width + mounting, width + mounting], [0, width + mounting] ];

  module back_mounting(width, thickness, thread_diameter = core_hole_M3(), full_cutout = false, additional_size = 5) {

    rotate([90, 0, 0]) difference() {
      if (full_cutout) {
        translate([-additional_size / 2, -additional_size / 2, 0])
          cube([width + mounting * 2 + additional_size, width + mounting * 2 + additional_size, thickness]);
      } else {
        cube([width + mounting * 2, width + mounting * 2, thickness]);
      }

      translate([mounting + border, mounting, -.1]) {
        cube([cutout, width, thickness + .2]);
        translate([width - cutout - border * 2, 0, 0])
          cube([cutout, width, thickness + .2]);

        translate([-border, 0, 2.1]) cube([width, width, thickness]);

        if (full_cutout) {
          translate([-border, 0, 0])
            cube([width, width, thickness + .2]);
        }
      }

      translate([mounting / 2, mounting / 2, -.1]) {
        for (i = [0:3]) {
          translate([threading[i][0], threading[i][1], 0])
            cylinder(d = thread_diameter, h = thickness + .2);
        }
      }
    }
  }

  translate([0, 5, 0]) back_mounting(width, thickness);
  back_mounting(width, 1.5, 3.2, true);
}

module pandargb_case(thickness = 2, tolerance = .1) {
  width = 46.3;
  depth = 64.2;
  hole_offset = 15;
  height = 5;
  
  rotate([90, 0, 0]) difference() {
    cube([width + thickness * 2, depth + thickness * 2, height + thickness]);

    translate([thickness, thickness, thickness])
      cube([width, depth, height + .1]);

    translate([thickness + hole_offset, thickness + hole_offset, -.1])
      cube([width - (thickness + hole_offset) * 2, depth - (thickness + hole_offset) * 2, height + .2]);
  }
}

module pump_plate(thickness = 2, tolerance = .15) {
  front_offset = 46;
  left_offset = 5;
  width = 165;
  tube_od = 14 + 1 + tolerance;
  tube_front_od = 20 + 1 + tolerance;
  tube_back_od = tube_od;
  agb_od = 60 + 1 + tolerance;
  tube_y = 54;
  tube_x = 15;

  rotate([90, 0, 0]) difference() {
    linear_extrude(thickness) {
      polygon([
        [0, 0],
        [width, 0],
        [width, 95 - front_offset],
        [width - 30, 95 - front_offset],
        [width - 30, 135 - front_offset],
        [width - 145, 135 - front_offset],
        [width - 145, 80 - front_offset],
        [0, 80 - front_offset],
      ]);
    }

    translate([95, 90 - front_offset, -.1]) union() {
      translate([-tube_y + 1, tube_x - 1, 0]) cylinder(d = tube_front_od, h = thickness + .2);
      cylinder(d = agb_od, h = thickness + .2);
      translate([tube_y, -tube_x, 0]) cylinder(d = tube_back_od, h = thickness + .2);
    }
  }
}

module pcie_power_plate(cables = 8, thickness = 2, tolerance = .15) {
  height = comb_width(cables, 2, 3.5, 1) + 7 * 4;
  width = comb_depth(2, 3.5, 1) + 7 * 2;

  // x, y, width, height
  cutout_atx24 = [ 7, 14, comb_depth(2, 3.5, 1), comb_width(cables, 2, 3.5, 1) ];

  rotate([-90, 0, 180]) translate([-width, -height, 0]) union() {
    difference() {
      cube([width, height, thickness]);

      translate([cutout_atx24[0] + .1, cutout_atx24[1] + .1, -.1])
        cube([cutout_atx24[2] - .2, cutout_atx24[3] - .2, thickness + .2]);

      translate([cutout_atx24[0] + cutout_atx24[2] / 2, cutout_atx24[1] - core_hole_M3() - .5, -.1]) {
        cylinder(d = 3.2, h = thickness + .2);
        translate([0, comb_mounting_distance(cables, 2, 3.5), 0])
          cylinder(d = 3.2, h = thickness + .2);
      }
    }
    translate([cutout_atx24[0] + cutout_atx24[2], cutout_atx24[1], 0]) rotate([0, 0, 90])
      comb(cables, 2, 3.5, with_chamfer = false);
  }
}

module drain_cover(od = 32, chamfer = 1, height_from_case = 4.6) {
  through_hole_thickness = 2.54;
  through_hole_diameter = 21;
  thickness = height_from_case - through_hole_thickness;

  rotate([90, 0, 0]) translate([od / 2, od / 2, 0]) intersection() {
    difference() {
      cylinder(d = od, h = through_hole_thickness);
      translate([0, 0, -.1]) cylinder(d = through_hole_diameter, h = through_hole_thickness + .2);
    }
    translate([0, 0, -.1])
      cylinder(d2 = od - chamfer * 2, d1 = od + (through_hole_thickness - chamfer) * 2, h = through_hole_thickness + .2);
  }
}

drain_cover();
rotate([0, 0, 90]) translate([0, 10, 0]) cable_combs();
translate([0,  20, 0]) pcie_riser_socket();
translate([0,  52, 0]) psu_brackets();
translate([0,  75, 0]) matrix_mounting();
translate([90, 75, 0]) pandargb_case();
translate([0,  80, 60]) ssd_cover();
translate([0,  80, 135]) psu_shroud();
translate([0,  85, 0]) mainboard_tray_cover();
translate([0,  90, 0]) pump_plate();
translate([0,  90, 95]) pcie_power_plate();
translate([0, 110, 0]) ddc_standoff_plate();
translate([0, 135, 0]) case_feet_citadel_mesh();
