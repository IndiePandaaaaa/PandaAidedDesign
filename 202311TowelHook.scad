// created by IndiePandaaaaa|Lukas

use <Parts/Screw.scad>

THICKNESS = 3.0;
SCREW_OD = 3.5;
CHAMFER = 1;

HOOK_INNER_WIDTH = 12;
DEPTH = SCREW_OD * 4;
HEIGHT = DEPTH * 2.5;

difference() {
    linear_extrude(DEPTH) {
        polygon([
                [0, CHAMFER],
                [CHAMFER, 0],
                [HOOK_INNER_WIDTH + THICKNESS * 2 - CHAMFER, 0],
                [HOOK_INNER_WIDTH + THICKNESS * 2, CHAMFER],
                [HOOK_INNER_WIDTH + THICKNESS * 2, HEIGHT],
                [HOOK_INNER_WIDTH + THICKNESS + CHAMFER, HEIGHT],
                [HOOK_INNER_WIDTH + THICKNESS, HEIGHT - CHAMFER],
                [HOOK_INNER_WIDTH + THICKNESS, THICKNESS + CHAMFER],
                [HOOK_INNER_WIDTH + THICKNESS - CHAMFER, THICKNESS],
                [THICKNESS + CHAMFER, THICKNESS],
                [THICKNESS, THICKNESS + CHAMFER],
                [THICKNESS, HEIGHT * 1 / 3 - CHAMFER],
                [THICKNESS - CHAMFER, HEIGHT * 1 / 3],
                [CHAMFER, HEIGHT * 1 / 3],
                [0, HEIGHT * 1 / 3 - CHAMFER],
            ]);
    }
    translate([HOOK_INNER_WIDTH + THICKNESS, HEIGHT - DEPTH / 2, DEPTH / 2])
        rotate([0, - 90, 0])
            screw(SCREW_OD, 12, true);
}
