// created by IndiePandaaaaa | Lukas

use <Parts/Screw.scad>

MODEL_TOLERANCE = 0.15;
MATERIAL_THICKNESS = 3;
fa = 0.1;

// Wavemaster MX3 dimensions
SOUNDBASE_OD = 70.3;
SOUNDBASE_OD_HEIGHT = 24.7;
CABLE_ANCHOR_CUTOUT = 14;
IO_CABLE_CUTOUT = 12;
IO_WIDTH = 42;
BRACKET_ID_OFFSET = 4.5;
MOUNTING_WIDTH = 25;

FULL_WIDTH = SOUNDBASE_OD + MODEL_TOLERANCE + MATERIAL_THICKNESS * 2 + MOUNTING_WIDTH;

difference() {
  union() {
    rotate_extrude($fa = fa) {
      polygon([
          [(SOUNDBASE_OD + MODEL_TOLERANCE) / 2, 0],
          [(SOUNDBASE_OD + MODEL_TOLERANCE) / 2,
            SOUNDBASE_OD_HEIGHT + MODEL_TOLERANCE],
          [(SOUNDBASE_OD + MODEL_TOLERANCE) / 2 - BRACKET_ID_OFFSET,
              SOUNDBASE_OD_HEIGHT + MODEL_TOLERANCE + BRACKET_ID_OFFSET * (55 / 45)],
          [(SOUNDBASE_OD + MODEL_TOLERANCE) / 2 - BRACKET_ID_OFFSET,
                SOUNDBASE_OD_HEIGHT + MODEL_TOLERANCE + BRACKET_ID_OFFSET * (55 / 45) +
            MATERIAL_THICKNESS],
          [(SOUNDBASE_OD + MODEL_TOLERANCE) / 2 + MATERIAL_THICKNESS,
              SOUNDBASE_OD_HEIGHT + MODEL_TOLERANCE + MATERIAL_THICKNESS],
          [(SOUNDBASE_OD + MODEL_TOLERANCE) / 2 + MATERIAL_THICKNESS, 0],
        ]);
    }
    difference() {
      factor_y = FULL_WIDTH / (SOUNDBASE_OD + MODEL_TOLERANCE);
      scale([1, factor_y, 1])
        cylinder(h = MATERIAL_THICKNESS, d = (SOUNDBASE_OD + MODEL_TOLERANCE),
        $fa = fa);
      translate([0, 0, -0.01])
        cylinder(h = MATERIAL_THICKNESS + 0.02, d = (SOUNDBASE_OD + MODEL_TOLERANCE), $fa = fa);
    }
  }

  translate([-(SOUNDBASE_OD - MATERIAL_THICKNESS) / 2, 0, CABLE_ANCHOR_CUTOUT / 4]) rotate([0, -90, 0])
    linear_extrude(10) {
      circle(d = CABLE_ANCHOR_CUTOUT / cos(30), $fn = 6);
    }

  translate([(SOUNDBASE_OD - MATERIAL_THICKNESS) / 2, 0, 16.2]) rotate([0, 90, 0]) {
    linear_extrude(10) {
      circle(d = 8, $fn = 6);
    }
    translate([-0.3, 0, -5])
      linear_extrude(10) {
        translate([0, -14, 0]) circle(d = IO_CABLE_CUTOUT / cos(30), $fn = 6);
        translate([0, 14, 0]) circle(d = IO_CABLE_CUTOUT / cos(30), $fn = 6);
      }
  }

  translate([0, (FULL_WIDTH - MOUNTING_WIDTH / 2) / 2, MATERIAL_THICKNESS]) screw(3.5, 12, true);
  translate([0, -(FULL_WIDTH - MOUNTING_WIDTH / 2) / 2, MATERIAL_THICKNESS]) screw(3.5, 12, true);
}


