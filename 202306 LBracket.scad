// created by IndiePandaaaaa | Lukas

use <Parts/Screw.scad>

MODEL_TOLERANCE = 0.15;

MATERIAL_THICKNESS = 3.5;
CHAMFER = 1;

WIDTH = 40; // WOOD - CHAMFER
SIDES = 12 + MATERIAL_THICKNESS;

SCREWS = 3;
SCREW_DIAMETER = 3.5;

SOLIDIFIER = SCREWS - 1;

difference() {
    width_inbetween = (WIDTH - MATERIAL_THICKNESS * SOLIDIFIER) / SCREWS;
    union() {
        linear_extrude(WIDTH) {
            polygon([
                    [0, 0],
                    [MATERIAL_THICKNESS, 0],
                    [MATERIAL_THICKNESS, SIDES - MATERIAL_THICKNESS - CHAMFER],
                    [MATERIAL_THICKNESS + CHAMFER, SIDES - MATERIAL_THICKNESS],
                    [SIDES, SIDES - MATERIAL_THICKNESS],
                    [SIDES, SIDES],
                    [CHAMFER, SIDES],
                    [0, SIDES - CHAMFER],
                ]);
        }

        for (i = [1:SOLIDIFIER]) {
            offset_z_solidifier = width_inbetween * i + MATERIAL_THICKNESS * (i - 1);
            translate([CHAMFER, 0, offset_z_solidifier])
                cube([SIDES - CHAMFER, SIDES - CHAMFER, MATERIAL_THICKNESS]);
        }
    }
    translate([MATERIAL_THICKNESS - CHAMFER, 0, 0]) rotate([0, 0, - 45]) cube(WIDTH);

    for (i = [0:SCREWS - 1]) {
        offset_z_screw = width_inbetween / 2 + (MATERIAL_THICKNESS + width_inbetween) * i;
        rotation = i % 2 == 1 ? [0, 90, - 90]:[0, 90, 0];
        translation = i % 2 == 1 ? [MATERIAL_THICKNESS + (SIDES - MATERIAL_THICKNESS) / 2, SIDES - MATERIAL_THICKNESS,
            offset_z_screw]:  [MATERIAL_THICKNESS, (SIDES - MATERIAL_THICKNESS) / 2, offset_z_screw];
        rotation = i % 2 == 1 ? [0, 90, - 90]:[0, 90, 0];
        translation = i % 2 == 1 ? [MATERIAL_THICKNESS + (SIDES - MATERIAL_THICKNESS) / 2, SIDES - MATERIAL_THICKNESS,
            offset_z_screw]:[MATERIAL_THICKNESS, (SIDES - MATERIAL_THICKNESS) / 2, offset_z_screw];

        translate(translation)
            rotate(rotation)
                screw(SCREW_DIAMETER, MATERIAL_THICKNESS * 2, true);
    }
}
