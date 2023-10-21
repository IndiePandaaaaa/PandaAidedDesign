// created by IndiePandaaaaa | Lukas

THICKNESS = 3.5;
TOLERANCE = 0.1;
CHAMFER = 1.5;

FULL_WIDTH = 148;  // width of the original support block
HEIGHT = 62;
DISTANCE_BETWEEN_HOOKS = 92.2;

TESTING_HOOK = false;

function bosch_hook_width() = 11.1;
function bosch_hook_depth() = 6.8;
function bosch_hook_height() = 12.3;

module bosch_hook() {
    base_material_thickness = 2;
    outer_width = bosch_hook_width();
    outer_height = bosch_hook_height();
    outer_depth = bosch_hook_depth();

    top_thickness = 1.6;
    hollow_depth = 3;
    hollow_height = 5.3;
    inner_piece_width = 7.5;
    translate([- base_material_thickness, outer_width, 0]) rotate([90, 0, 0]) union() {
        linear_extrude(outer_width) {
            polygon([
                    [0, 0],
                    [base_material_thickness, 0],
                    [base_material_thickness, outer_height - top_thickness],
                    [base_material_thickness + hollow_depth, outer_height - top_thickness],
                    [base_material_thickness + hollow_depth, 0],
                    [base_material_thickness + outer_depth, 0],
                    [base_material_thickness + outer_depth, outer_height],
                    [0, outer_height],
                ]);
        }
        translate([outer_depth, outer_height, outer_width]) rotate([0, 90, 180]) linear_extrude(outer_depth) {
            distance_to_center = (outer_width - inner_piece_width) / 2;
            polygon([
                    [0, 0],
                    [distance_to_center, 0],
                    [distance_to_center, outer_height - hollow_height],
                    [distance_to_center + inner_piece_width, outer_height - hollow_height],
                    [distance_to_center + inner_piece_width, 0],
                ]);
        }
    }
}
translate([THICKNESS, - ((DISTANCE_BETWEEN_HOOKS + bosch_hook_width() * 2) - FULL_WIDTH) / 2, 10]) {
    bosch_hook();
    translate([0, DISTANCE_BETWEEN_HOOKS + bosch_hook_width(), 0]) bosch_hook();
}
cube([THICKNESS, FULL_WIDTH, HEIGHT]);

if (TESTING_HOOK) {
    translate([42, 0, 0]) {
        cube([20, bosch_hook_width(), bosch_hook_height()]);
        rotate([0, 0, 180]) translate([2, - bosch_hook_width(), 0]) bosch_hook();
    }
}