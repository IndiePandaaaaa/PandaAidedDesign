// created by IndiePandaaaaa|Lukas

use <Parts/ZipTiePoint.scad>
use <Parts/Screw.scad>

MATERIAL_THICKNESS = 2.5;
TOLERANCE = 0.1;
FN = $preview ? 25 : 120;

INPUT_CABLE_COUNT = 6; // one will be add later as output

LUSTER_TERMINAL_LENGTH = 50;
LUSTER_TERMINAL_WIDTH = 15;
LUSTER_TERMINAL_HEIGHT = 12;

CABLE_DIAMETER = 8;
CABLE_LENGTH_TERMINAL = 25; // size for left and right sided input symmetrical, size for one side

BOX_INTERNAL_TOLERANCE = 3;
BOX_HEIGHT = LUSTER_TERMINAL_HEIGHT + BOX_INTERNAL_TOLERANCE + MATERIAL_THICKNESS;
BOX_WIDTH = LUSTER_TERMINAL_WIDTH + CABLE_LENGTH_TERMINAL * 2 + BOX_INTERNAL_TOLERANCE * 2;
BOX_DEPTH = round(((CABLE_DIAMETER + BOX_INTERNAL_TOLERANCE) * (INPUT_CABLE_COUNT + 1)) / 2 + 0.5) +
    MATERIAL_THICKNESS * 2 + MATERIAL_THICKNESS + CABLE_LENGTH_TERMINAL;

SCREW_DIAMETER = 3.5;
SCREWS = 2; // not modifiable

module single_cable_terminal() {
  cube([MATERIAL_THICKNESS, CABLE_DIAMETER + TOLERANCE, BOX_HEIGHT]);
  translate([0, CABLE_DIAMETER / 2, 0]) rotate([0, 90, 0])
    cylinder(d = CABLE_DIAMETER + TOLERANCE, h = MATERIAL_THICKNESS, $fn = FN);
}

module basic_box() {
  linear_extrude(MATERIAL_THICKNESS) {
    polygon([
        [0, 0],
        [BOX_WIDTH, 0],
        [BOX_WIDTH, BOX_DEPTH],
        [0, BOX_DEPTH],
      ]);
  }
  linear_extrude(BOX_HEIGHT) {
    difference() {
      polygon([
          [0, 0],
          [BOX_WIDTH, 0],
          [BOX_WIDTH, BOX_DEPTH],
          [0, BOX_DEPTH],
        ]);
      polygon([
          [MATERIAL_THICKNESS, MATERIAL_THICKNESS],
          [BOX_WIDTH - MATERIAL_THICKNESS, MATERIAL_THICKNESS],
          [BOX_WIDTH - MATERIAL_THICKNESS, BOX_DEPTH - MATERIAL_THICKNESS],
          [MATERIAL_THICKNESS, BOX_DEPTH - MATERIAL_THICKNESS],
        ]);
    }
  }
}

difference() {
  union() {
    difference() {
      basic_box();

      for (i = [0:round(INPUT_CABLE_COUNT / 2)]) {
        translate([0, MATERIAL_THICKNESS + CABLE_LENGTH_TERMINAL / 2 + (BOX_INTERNAL_TOLERANCE + CABLE_DIAMETER)
          * i, BOX_HEIGHT / 2]) {
          single_cable_terminal();
          translate([BOX_WIDTH - MATERIAL_THICKNESS, 0, 0]) single_cable_terminal();
        }
      }
    }
    for (i = [0:SCREWS - 1]) {
      translate([(BOX_WIDTH - MATERIAL_THICKNESS * 2 - LUSTER_TERMINAL_WIDTH - BOX_INTERNAL_TOLERANCE * 2) / 2 +
          (LUSTER_TERMINAL_WIDTH + BOX_INTERNAL_TOLERANCE * 2) * i,
              SCREW_DIAMETER / 2 + MATERIAL_THICKNESS +
            (BOX_WIDTH - MATERIAL_THICKNESS - SCREW_DIAMETER * 1.5) * i, 0])
        cylinder(d = SCREW_DIAMETER * 2, h = BOX_HEIGHT, $fn = FN);
    }
  }
  for (i = [0:SCREWS - 1]) {
    translate([(BOX_WIDTH - MATERIAL_THICKNESS * 2 - LUSTER_TERMINAL_WIDTH - BOX_INTERNAL_TOLERANCE * 2) / 2 +
        (LUSTER_TERMINAL_WIDTH + BOX_INTERNAL_TOLERANCE * 2) * i,
            SCREW_DIAMETER / 2 + MATERIAL_THICKNESS +
          (BOX_WIDTH - MATERIAL_THICKNESS - SCREW_DIAMETER * 1.5) * i, 0])
      rotate([0, 180, 0]) screw(SCREW_DIAMETER, BOX_HEIGHT, cutout_sample = true);
  }
}
