// created by IndiePandaaaaa | Lukas

use <202304hddBayStackable.scad>
use <Structures/Hexagon.scad>

MODEL_TOLERANCE = 0.15;
TOLERANCE_HDD = 1;

UBASE_THICKNESS = 4;
POST_DEPTH = 7;
POST_DEPTH_SCREW_IN = 16;

WIDTH_HDD = 101.5;
HEIGHT_HDD = 26.5;
FAN_CaseMountingSocket_DISTANCE = 105; // 105 mm is the distance between screws for an 120 mm fan

HDD_BOTTOM_SCREW_DEPTH = 41.3;
HDD_BOTTOM_SCREW_POS_X = 3.2;
HDD_SATA_CONNECTOR_WIDTH = 53;
HDD_SATA_CONNECTOR_POS_X = 7.8;
HDD_SATA_CONNECTOR_HEIGHT = 9;
HDD_SATA_CONNECTOR_CABLE_DEPTH = 39.5;

RUBBER_HEIGHT = 2.3;
RUBBER_WIDTH_ADDITIONAL = 1.3;
RUBBER_HEIGHT_INTERNAL = 1.5;
RUBBER_OD = 10;
RUBBER_OD_ID = 6.2;

SCREW_LENGTH = 12 + 2;  // additionally 2mm for less tolerance issues with threading
SCREW_SOCKET_WIDTH = 10;

FULLMODEL_DEPTH = SCREW_LENGTH + HDD_BOTTOM_SCREW_DEPTH + 55; // ~ 110 mm
FULLMODEL_HEIGHT = UBASE_THICKNESS + 4; // ~ 8 mm total height
FULLMODEL_WIDTH = UBASE_THICKNESS * 2 + TOLERANCE_HDD * 2 + WIDTH_HDD + 2 * RUBBER_WIDTH_ADDITIONAL;

difference() {
  translate([0, FULLMODEL_DEPTH, 0]) rotate([90, 0, 0])
    UBase(FULLMODEL_DEPTH, FULLMODEL_HEIGHT, WIDTH_HDD + 2 * RUBBER_WIDTH_ADDITIONAL,
    TOLERANCE_HDD, UBASE_THICKNESS);

  inner_model_width = FULLMODEL_WIDTH - UBASE_THICKNESS * 2;
  hex_od = 20;
  pos_x = UBASE_THICKNESS + (inner_model_width - hexagon_get_used_width(inner_model_width, hex_od)) / 2;
  pos_y = (FULLMODEL_DEPTH - hexagon_get_used_depth(FULLMODEL_DEPTH, hex_od)) / 2;

  translate([pos_x, pos_y, 0])
    hexagon_pattern(inner_model_width, FULLMODEL_DEPTH, UBASE_THICKNESS, hex_od);
}
