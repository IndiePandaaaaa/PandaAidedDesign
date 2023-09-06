// created by IndiePandaaaaa | Lukas

use <Parts/Screw.scad>

MODEL_TOLERANCE = 0.1;
MODEL_THICKNESS = 3;
FN = 42;

PLATE_WIDTH = 14;
PLATE_DEPTH = 60;

WOOD_BOARD_THICKNESS = 13;
WOOD_BOARD_WIDTH = 30;
WOOD_BOARD_SCREW_DIST = WOOD_BOARD_WIDTH - 3.5 * 2;

FULL_WIDTH = 30 + PLATE_WIDTH;

BREMOUNTA_SCREW_DIST = 50;
BREMOUNTA_SCREW_ID = 6.5;
BREMOUNTA_SCREW_OD = BREMOUNTA_SCREW_ID + 1;
BREMOUNTA_SCREW_OD_DEPTH = 1.5;

difference() {
    union() {
        cube([FULL_WIDTH, PLATE_DEPTH, MODEL_THICKNESS]);
        cube([PLATE_WIDTH, PLATE_DEPTH, WOOD_BOARD_THICKNESS]);
    }
    for (i = [0:1]) {
        translate([PLATE_WIDTH / 2, (PLATE_DEPTH - BREMOUNTA_SCREW_DIST + BREMOUNTA_SCREW_OD) / 2, 0]) {
            translate([0, (BREMOUNTA_SCREW_DIST - BREMOUNTA_SCREW_OD) * i, 0]) {
                translate([0, 0, WOOD_BOARD_THICKNESS - BREMOUNTA_SCREW_OD_DEPTH])
                    cylinder(d = BREMOUNTA_SCREW_OD, h = BREMOUNTA_SCREW_OD_DEPTH, $fn = FN);
                rotate([180, 0, 0]) screw(6, 30, true);
                translate([FULL_WIDTH - PLATE_WIDTH, 0, 3.5]) screw(3.5, 12, true);
            }
        }
        translate([PLATE_WIDTH, (PLATE_DEPTH - WOOD_BOARD_SCREW_DIST) / 2 + WOOD_BOARD_SCREW_DIST * i,
                WOOD_BOARD_THICKNESS / 2]) rotate([0, 90, 0]) screw(3.5, 35, true);
    }
}
