// created by IndiePandaaaaa|Lukas
// encoding: utf-8

use <Parts/Screw.scad>

TOLERANCE = .1;
THICKNESS = 2.5;
$fn = $preview ? 25:125;

// width of stand, depth, height, bracket width, distance inbetween brackets
DEVICE_SIZE = [32, 42, 24, 10, 20];
DEVICE_ANGLE = 42;

// depth, height; [0, 0] for no standoff
STANDOFF_SIZE = [0, 0];

// short version to add TOLERANCE to values
function t(value) = value + TOLERANCE;

module device_bracket(depth=5) {
  back_height = 3;
  front_depth = 5;
  translate([0, depth, 0]) rotate([90, 0, 0]) linear_extrude(depth) {
    polygon([
      [0, 0],
      [t(DEVICE_SIZE[1]) + THICKNESS*2, 0],
      [t(DEVICE_SIZE[1]) + THICKNESS*2, back_height + THICKNESS*2],
      [t(DEVICE_SIZE[1]) + THICKNESS, back_height + THICKNESS*2],
      [t(DEVICE_SIZE[1]) + THICKNESS, THICKNESS],
      [THICKNESS, THICKNESS],
      [THICKNESS, t(DEVICE_SIZE[2]) + THICKNESS],
      [THICKNESS + front_depth, t(DEVICE_SIZE[2]) + THICKNESS],
      [THICKNESS + front_depth, t(DEVICE_SIZE[2]) + THICKNESS*2],
      [0, t(DEVICE_SIZE[2]) + THICKNESS*2],
    ]);
  }
}

function standoff_length() = cos(DEVICE_ANGLE)*DEVICE_SIZE[1];

function standoff_height() = sin(DEVICE_ANGLE)*DEVICE_SIZE[1];

module standoff_base(depth=5) {
  length = standoff_length();
  height = standoff_height();

  translate([0, depth, 0]) rotate([90, 0, 0]) linear_extrude(depth) {
    polygon([
      [0, 0],
      [length + THICKNESS, 0],
      [length + THICKNESS, standoff_height() + tan(DEVICE_ANGLE)*THICKNESS + TOLERANCE],
      [length, standoff_height() + TOLERANCE],
      [length, THICKNESS],
      [0, THICKNESS],
    ]);
  }
}

union() {
  for (i=[0:1]) {
    translate([0, DEVICE_SIZE[4]*i, 0]) {
      translate([0, 0, STANDOFF_SIZE[1]]) rotate([0, -DEVICE_ANGLE, 0]) device_bracket(DEVICE_SIZE[3]);
      standoff_base(DEVICE_SIZE[3]);
    }
  }
}

