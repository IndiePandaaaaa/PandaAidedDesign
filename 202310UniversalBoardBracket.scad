// created by IndiePandaaaaa | Lukas

use <Parts/Screw.scad>

THICKNESS = 3.5;
TOLERANCE = 0.1;
CHAMFER = 1.5;
SCREW_OD = 3.5;
$fn = 75;

BOARD_THICKNESS = 20.8;
MOUNT_HEIGHT = 20;
ANGLE = 15;

// todo: implement angled mounting

difference() {
    linear_extrude(SCREW_OD * 4) {
        polygon([
                [0, CHAMFER],
                [CHAMFER, 0],
                [THICKNESS, 0],
                [THICKNESS, BOARD_THICKNESS],
                [THICKNESS + BOARD_THICKNESS + TOLERANCE, BOARD_THICKNESS],
                [THICKNESS + BOARD_THICKNESS + TOLERANCE, 0],
                [THICKNESS * 2 + BOARD_THICKNESS + TOLERANCE - CHAMFER, 0],
                [THICKNESS * 2 + BOARD_THICKNESS + TOLERANCE, CHAMFER],
                [THICKNESS * 2 + BOARD_THICKNESS + TOLERANCE, BOARD_THICKNESS + THICKNESS],
                [THICKNESS * 2 + BOARD_THICKNESS + TOLERANCE, BOARD_THICKNESS + THICKNESS + MOUNT_HEIGHT],
                [THICKNESS + BOARD_THICKNESS + TOLERANCE, BOARD_THICKNESS + THICKNESS + MOUNT_HEIGHT],
                [THICKNESS + BOARD_THICKNESS + TOLERANCE, BOARD_THICKNESS + THICKNESS],
                [CHAMFER, BOARD_THICKNESS + THICKNESS],
                [0, BOARD_THICKNESS + THICKNESS - CHAMFER],
            ]);
    }
    translate([THICKNESS * 2 + BOARD_THICKNESS + TOLERANCE, BOARD_THICKNESS + MOUNT_HEIGHT + THICKNESS - SCREW_OD * 2,
            SCREW_OD * 2]) rotate([0, 90, 0]) screw(SCREW_OD, 12, true);
}
