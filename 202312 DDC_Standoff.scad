// created by IndiePandaaaaa
// utf-8

use <Variables/Threading.scad>

// DDC for reference: EK Quantum Kinect DDC 120

THICKNESS = 3;
TOLERANCE = .1;
CHAMFER = 1;
$fn = 75;

SCREW_DISTANCE = 50;
SCREW_DIAMETER = 4;
SCREW_HEAD_HEIGHT = 3;
SCREW_HEAD_DIAMETER = 7;
SCREW_TOLERANCE = 1;

PLATE_SIZE = 64;
PLATE_HEIGHT = 13.5;

difference() {
  linear_extrude(PLATE_HEIGHT) {
    polygon([
      [CHAMFER, 0],
      [PLATE_SIZE - CHAMFER, 0],
      [PLATE_SIZE, CHAMFER],
      [PLATE_SIZE, PLATE_SIZE - CHAMFER],
      [PLATE_SIZE - CHAMFER, PLATE_SIZE],
      [CHAMFER, PLATE_SIZE],
      [0, PLATE_SIZE - CHAMFER],
      [0, CHAMFER],
    ]);
  }

  for (y = [0:1]) {
    for (x = [0:1]) {
      edge_dist = PLATE_SIZE > SCREW_DISTANCE ? (PLATE_SIZE - SCREW_DISTANCE) / 2 : SCREW_HEAD_DIAMETER + SCREW_TOLERANCE;
      translate([edge_dist + SCREW_DISTANCE * x, edge_dist + SCREW_DISTANCE * y, 0]) {
        cylinder(d = SCREW_DIAMETER + SCREW_TOLERANCE, h = PLATE_HEIGHT);
        cylinder(d = SCREW_HEAD_DIAMETER + SCREW_TOLERANCE, h = PLATE_HEIGHT - SCREW_TOLERANCE * 2);
      }
      translate([edge_dist + SCREW_DISTANCE * y, PLATE_SIZE / 2, 0])
        cylinder(d = core_hole_M4(), h = PLATE_SIZE);
    }
  }
}
