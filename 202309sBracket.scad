// created by IndiePandaaaaa|Lukas

use <Parts/Screw.scad>

TOLERANCE = 0.1;
THICKNESS = 3;
SCREW_OD = 3.5;

SCREWS_2 = true;
SCREWS_2_DIST = 25;  // IKEA PLATSA hole distance

BRACKET_INNER_HEIGHT = 26;  // height tplink ethernet switch 8 port
BRACKET_SCREW_DEPTH = 12;
BRACKET_UPPER_WIDTH = 12;
BRACKET_WIDTH = SCREWS_2_DIST + SCREW_OD * 2 + 1.5 * 2;  // if too low SCREWS_2 has priority

difference() {
    translate([0, BRACKET_WIDTH, 0]) rotate([90, 0, 0])
        linear_extrude(BRACKET_WIDTH) {
            polygon([
                    [0, 0],
                    [BRACKET_SCREW_DEPTH + THICKNESS, 0],
                    [BRACKET_SCREW_DEPTH + THICKNESS, BRACKET_INNER_HEIGHT + TOLERANCE - 0.5],
                // -0.5 fitting for device
                    [BRACKET_SCREW_DEPTH + THICKNESS + BRACKET_UPPER_WIDTH, BRACKET_INNER_HEIGHT + TOLERANCE - 0.5],
                    [BRACKET_SCREW_DEPTH + THICKNESS + BRACKET_UPPER_WIDTH, BRACKET_INNER_HEIGHT + THICKNESS],
                    [BRACKET_SCREW_DEPTH, BRACKET_INNER_HEIGHT + THICKNESS],
                    [BRACKET_SCREW_DEPTH, THICKNESS],
                    [0, THICKNESS],
                ]);
        }

    for (i = [0:1]) {
        if (SCREWS_2) {
            translate([BRACKET_SCREW_DEPTH / 2,
                    (BRACKET_WIDTH - SCREWS_2_DIST - SCREW_OD - 1.5) + SCREWS_2_DIST * i, THICKNESS])
                screw(SCREW_OD, 12, true);
        } else {
            translate([BRACKET_SCREW_DEPTH / 2, BRACKET_WIDTH / 2, THICKNESS])
                screw(SCREW_OD, 12, true);
        }
    }
}
