// created by IndiePandaaaaa | Lukas

use <Parts/Screw.scad>

MODEL_TOLERANCE = 0.1;
MODEL_THICKNESS = 3;
FN = 42;

SOCKET_WIDTH = 14;
PLATE_DEPTH = 58;
PLATE_WIDTH = 21 + SOCKET_WIDTH;
PLATE_SCREW_OD = 3.5;

WOOD_BOARD_THICKNESS = 9;
WOOD_BOARD_WIDTH = 28;
WOOD_BOARD_SCREW_DIST = WOOD_BOARD_WIDTH - 3.5 * 2;

BREMOUNTA_SCREW_DIST = 50;
BREMOUNTA_SCREW_OD = 6;
BREMOUNTA_SCREW_HOLE_ID = 6.5;
BREMOUNTA_SCREW_HOLE_OD = BREMOUNTA_SCREW_HOLE_ID + 1;
BREMOUNTA_SCREW_HOLE_OD_DEPTH = 1;


difference() {
    union() {
        cube([PLATE_WIDTH, PLATE_DEPTH, MODEL_THICKNESS]);
        cube([SOCKET_WIDTH, PLATE_DEPTH, WOOD_BOARD_THICKNESS]);
        translate([0, PLATE_DEPTH / 5, 0]) cube([SOCKET_WIDTH * 1.75, PLATE_DEPTH / 5 * 3, WOOD_BOARD_THICKNESS]);
    }
    for (i = [0:1]) {
        translate([SOCKET_WIDTH / 2, (PLATE_DEPTH - BREMOUNTA_SCREW_DIST + BREMOUNTA_SCREW_HOLE_OD) / 2, 0]) {
            translate([0, (BREMOUNTA_SCREW_DIST - BREMOUNTA_SCREW_HOLE_OD) * i, 0]) {
                translate([0, 0, WOOD_BOARD_THICKNESS - BREMOUNTA_SCREW_HOLE_OD_DEPTH])
                    cylinder(d = BREMOUNTA_SCREW_HOLE_OD, h = BREMOUNTA_SCREW_HOLE_OD_DEPTH, $fn = FN);
                rotate([180, 0, 0]) screw(BREMOUNTA_SCREW_OD, 30, true);
                translate([PLATE_WIDTH - SOCKET_WIDTH, 0, PLATE_SCREW_OD]) screw(PLATE_SCREW_OD, 12, true);
            }
        }
        if (WOOD_BOARD_THICKNESS > PLATE_SCREW_OD * 2) {
            translate([SOCKET_WIDTH * 1.75, (PLATE_DEPTH - WOOD_BOARD_SCREW_DIST) / 2 + WOOD_BOARD_SCREW_DIST * i,
                    WOOD_BOARD_THICKNESS / 2]) rotate([0, 90, 0]) {
                screw(PLATE_SCREW_OD, 35, true);
                cylinder(d = PLATE_SCREW_OD * 2, h = PLATE_WIDTH, $fn = FN);
            }
        }
    }
}
