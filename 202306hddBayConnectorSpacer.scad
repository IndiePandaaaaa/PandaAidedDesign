// created by IndiePandaaaaa | Lukas

use <202304 HDD_Bay_stackable.scad>
use <Structures/Hexagon.scad>

MODEL_TOLERANCE = 0.15;
TOLERANCE_HDD = 1;

SATA_CONNECTORS = 3;
SATA_CONNECTOR_WIDTH = 16;

WITH_DIAMOND_CUTOUT = false;

SCREW_LENGTH = 12 + 2;  // additionally 2mm for less tolerance issues with threading
SCREW_SOCKET_WIDTH = 10;
FAN_CaseMountingSocket_DISTANCE = 105; // 105 mm is the distance between screws for an 120 mm fan
HDD_BOTTOM_SCREW_DEPTH = 41.3;
UBASE_THICKNESS = 4;
WIDTH_HDD = 101.5;
RUBBER_WIDTH_ADDITIONAL = 1.3;

FULLMODEL_DEPTH = SCREW_LENGTH + HDD_BOTTOM_SCREW_DEPTH + 55; // ~ 110 mm
FULLMODEL_HEIGHT = UBASE_THICKNESS + SATA_CONNECTORS * SATA_CONNECTOR_WIDTH; // ~ 53 mm height (~15mm per connector)
FULLMODEL_WIDTH = UBASE_THICKNESS * 2 + TOLERANCE_HDD * 2 + WIDTH_HDD + 2 * RUBBER_WIDTH_ADDITIONAL;

X_ANGLE = 52;

union() {
  difference() {
    UBase(FULLMODEL_DEPTH, FULLMODEL_HEIGHT, WIDTH_HDD + 2 * RUBBER_WIDTH_ADDITIONAL,
    TOLERANCE_HDD, UBASE_THICKNESS);
    translate([0, UBASE_THICKNESS, 0])
      cube([FULLMODEL_WIDTH, FULLMODEL_HEIGHT - UBASE_THICKNESS * 2, FULLMODEL_DEPTH + 1]);
    translate([UBASE_THICKNESS, 0, 0])
      cube([FULLMODEL_WIDTH - UBASE_THICKNESS * 2, FULLMODEL_HEIGHT, FULLMODEL_DEPTH + 1]);
  }

  difference() {
    slope_height = (FULLMODEL_HEIGHT - UBASE_THICKNESS) / 2;
    slope_width = tan(X_ANGLE) * slope_height;
    width_offset = 12;
    linear_extrude(FULLMODEL_DEPTH) {
      polygon([
          [UBASE_THICKNESS, UBASE_THICKNESS],
          [UBASE_THICKNESS, 0],
          [UBASE_THICKNESS + width_offset, 0],
          [UBASE_THICKNESS + width_offset + slope_width, slope_height - UBASE_THICKNESS / 2],
          [FULLMODEL_WIDTH - width_offset - UBASE_THICKNESS - slope_width,
            slope_height - UBASE_THICKNESS / 2],
          [FULLMODEL_WIDTH - width_offset, 0],
          [FULLMODEL_WIDTH - UBASE_THICKNESS, 0],
          [FULLMODEL_WIDTH - UBASE_THICKNESS, UBASE_THICKNESS],
          [FULLMODEL_WIDTH - width_offset, UBASE_THICKNESS],
          [FULLMODEL_WIDTH - width_offset - slope_width, slope_height + UBASE_THICKNESS / 2],
          [FULLMODEL_WIDTH - width_offset, FULLMODEL_HEIGHT - UBASE_THICKNESS],
          [FULLMODEL_WIDTH, FULLMODEL_HEIGHT - UBASE_THICKNESS],
          [FULLMODEL_WIDTH, FULLMODEL_HEIGHT],
          [FULLMODEL_WIDTH - UBASE_THICKNESS - width_offset, FULLMODEL_HEIGHT],
          [FULLMODEL_WIDTH - UBASE_THICKNESS - width_offset - slope_width,
              FULLMODEL_HEIGHT - slope_height + UBASE_THICKNESS / 2],
          [UBASE_THICKNESS + width_offset + slope_width,
              FULLMODEL_HEIGHT - slope_height + UBASE_THICKNESS / 2],
          [width_offset + UBASE_THICKNESS, FULLMODEL_HEIGHT],
          [0, FULLMODEL_HEIGHT],
          [0, FULLMODEL_HEIGHT - UBASE_THICKNESS],
          [width_offset, FULLMODEL_HEIGHT - UBASE_THICKNESS],
          [width_offset + slope_width, slope_height + UBASE_THICKNESS / 2],
          [width_offset, UBASE_THICKNESS],
        ]);
    }

    if (WITH_DIAMOND_CUTOUT) {
      translate([0, FULLMODEL_HEIGHT, 0]) rotate([90, 0, 0]) {
        linear_extrude(FULLMODEL_HEIGHT) {
          middle_width = (FULLMODEL_WIDTH - width_offset - UBASE_THICKNESS) -
            (UBASE_THICKNESS + width_offset + slope_width);
          polygon([
              [UBASE_THICKNESS + width_offset + UBASE_THICKNESS, width_offset * 2],
              [UBASE_THICKNESS + width_offset + slope_width / 2, UBASE_THICKNESS * 2],
              [UBASE_THICKNESS + width_offset + slope_width - UBASE_THICKNESS, width_offset * 2],
              [UBASE_THICKNESS + width_offset + slope_width - UBASE_THICKNESS,
                FULLMODEL_DEPTH - width_offset * 2],
              [UBASE_THICKNESS + width_offset + slope_width / 2, FULLMODEL_DEPTH - UBASE_THICKNESS * 2],
              [UBASE_THICKNESS + width_offset + UBASE_THICKNESS, FULLMODEL_DEPTH - width_offset * 2],
            ]);
          polygon([
              [UBASE_THICKNESS + middle_width + width_offset + UBASE_THICKNESS, width_offset * 2],
              [UBASE_THICKNESS + middle_width + width_offset + slope_width / 2, UBASE_THICKNESS * 2],
              [UBASE_THICKNESS + middle_width + width_offset + slope_width - UBASE_THICKNESS,
                width_offset * 2],
              [UBASE_THICKNESS + middle_width + width_offset + slope_width - UBASE_THICKNESS,
                FULLMODEL_DEPTH - width_offset * 2],
              [UBASE_THICKNESS + middle_width + width_offset + slope_width / 2,
                FULLMODEL_DEPTH - UBASE_THICKNESS * 2],
              [UBASE_THICKNESS + middle_width + width_offset + UBASE_THICKNESS,
                FULLMODEL_DEPTH - width_offset * 2],
            ]);
        }
      }
    }
  }
  translate([0, FULLMODEL_HEIGHT - UBASE_THICKNESS, 0]) rotate([90, 0, 0])
    CaseMountingSocket(SCREW_SOCKET_WIDTH, SCREW_LENGTH, FULLMODEL_HEIGHT / 2, FAN_CaseMountingSocket_DISTANCE,
    FULLMODEL_WIDTH, for_cutout_only = false);
}
