// created by IndiePandaaaaa | Lukas

use <Parts/Screw.scad>

THICKNESS = 3;
TOLERANCE = 0.1;
SCREW_OD = 6;
$fn = 75;

WOOD_SIZE = 53;
CHAMFER = 2.0;

outer_width = WOOD_SIZE + THICKNESS * 2 + TOLERANCE;
inner_width = WOOD_SIZE + TOLERANCE;
HEIGHT = outer_width; //  SCREW_OD * 4 + 34;
translate([-outer_width / 2, -outer_width / 2, 0]) {
  difference() {
    linear_extrude(HEIGHT) {
      difference() {
        polygon([
            [0, CHAMFER],
            [CHAMFER, 0],
            [outer_width - CHAMFER, 0],
            [outer_width, CHAMFER],
            [outer_width, outer_width - CHAMFER],
            [outer_width - CHAMFER, outer_width],
            [CHAMFER, outer_width],
            [0, outer_width - CHAMFER],
          ]);
        polygon([
            [THICKNESS, THICKNESS + CHAMFER],
            [THICKNESS + CHAMFER, THICKNESS],
            [THICKNESS + inner_width - CHAMFER, THICKNESS],
            [THICKNESS + inner_width, THICKNESS + CHAMFER],
            [THICKNESS + inner_width, THICKNESS + inner_width - CHAMFER],
            [THICKNESS + inner_width - CHAMFER, THICKNESS + inner_width],
            [THICKNESS + CHAMFER, THICKNESS + inner_width],
            [THICKNESS, THICKNESS + inner_width - CHAMFER],
          ]);
      }
    }
    for (i = [0:1]) {
      rotate([90, 0, -90 * i])
        translate([outer_width / 4 - outer_width * i, SCREW_OD * 2, 0])
          screw(SCREW_OD, 35, true);
      rotate([90, 0, -180 - 90 * i])
        translate([outer_width / 4 + outer_width * (-1 + i), SCREW_OD * 2, outer_width])
          screw(SCREW_OD, 35, true);

      rotate([90, 0, 90 * i])
        translate([outer_width / 4 * 3, HEIGHT - SCREW_OD * 2, outer_width * i])
          screw(SCREW_OD, 35, true);
      rotate([90, 0, 180 + 90 * i])
        translate([outer_width / 4 * 3 + outer_width * -1, HEIGHT - SCREW_OD * 2, -outer_width * (i == 1 ? 0:-
        1)])
          screw(SCREW_OD, 35, true);
    }
  }
}

















