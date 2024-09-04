// created by IndiePandaaaaa
// utf-8

use <Variables/Threading.scad>

$fn = 75;

// DDC for reference: EK Quantum Kinect DDC 120
module ddc_standoff(plate_height, thickness = 3, tolerance = .1, chamfer = 1) {
  screw_distance = 50;
  screw_diameter = 4;
  screw_head_height = 3;
  screw_head_diameter = 7;
  screw_tolerance = 1;

  plate_size = screw_distance + screw_head_diameter * 2;

  difference() {
    linear_extrude(plate_height) {
      polygon([
        [chamfer, 0],
        [plate_size - chamfer, 0],
        [plate_size, chamfer],
        [plate_size, plate_size - chamfer],
        [plate_size - chamfer, plate_size],
        [chamfer, plate_size],
        [0, plate_size - chamfer],
        [0, chamfer],
      ]);
    }

    for (y = [0:1]) {
      for (x = [0:1]) {
        edge_dist = plate_size > screw_distance ? (plate_size - screw_distance) / 2 : screw_head_diameter + screw_tolerance;
        translate([edge_dist + screw_distance * x, edge_dist + screw_distance * y, -.1]) {
          cylinder(d = screw_diameter + screw_tolerance, h = plate_height + .2);
          cylinder(d = screw_head_diameter + screw_tolerance, h = plate_height - screw_tolerance * 2 + .1);
        }
        translate([edge_dist + screw_distance * y, plate_size / 2, -.1])
          cylinder(d = core_hole_M4(), h = plate_size + .2);
      }
    }
  }
}

ddc_standoff(plate_height = 13.5);
