// created by IndiePandaaaaa | Lukas

use <Parts/Screw.scad>

MODEL_TOLERANCE = 0.1;
MODEL_THICKNESS = 3.5;
FN = 42;

SOCKET_WIDTH = 14;
PLATE_DEPTH = 63;  // Bremounta 58mm
PLATE_SCREW_OD = 6;

BREMOUNTA_SCREW_DIST = 50;
BREMOUNTA_SCREW_OD = 6;
BREMOUNTA_SCREW_HOLE_ID = 6.5;
BREMOUNTA_SCREW_HOLE_OD = BREMOUNTA_SCREW_HOLE_ID + 1;
BREMOUNTA_SCREW_HOLE_OD_DEPTH = 1;

WOOD_SCREWIN_THICKNESS = 20;

difference() {
    union() {
        cube([SOCKET_WIDTH, MODEL_THICKNESS, PLATE_DEPTH + MODEL_TOLERANCE + MODEL_THICKNESS]);
        cube([SOCKET_WIDTH, WOOD_SCREWIN_THICKNESS, MODEL_THICKNESS]);
    }
    translate([SOCKET_WIDTH / 2, WOOD_SCREWIN_THICKNESS / 2, MODEL_THICKNESS])
        rotate([0, 0, 90]) screw(PLATE_SCREW_OD, 12, true);

    for (i = [0:1]) {
        translate([SOCKET_WIDTH / 2, 0, BREMOUNTA_SCREW_OD + MODEL_THICKNESS + BREMOUNTA_SCREW_DIST * i]) {
            rotate([90, 0, 0]) {
                screw(BREMOUNTA_SCREW_OD, 12, true);
                translate([0, 0, - MODEL_THICKNESS])
                    cylinder(d = BREMOUNTA_SCREW_HOLE_OD, h = BREMOUNTA_SCREW_HOLE_OD_DEPTH, $fn = FN);
            }
        }
    }
}
