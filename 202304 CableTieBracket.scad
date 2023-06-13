// created by IndiePandaaaaa | Lukas

use <Parts/Screw.scad>
use <Parts/ZipTiePoint.scad>

MODEL_TOLERANCE = 0.15;
MATERIAL_THICKNESS = 2.5;
DISTANCE_X = 2;
DISTANCE_Z = DISTANCE_X;

SCREWS = 2;
SCREW_DIAMETER = 3.5;

ZIP_TIES = 5;
ZIP_TIE_WIDTH = 2.5;
ZIP_TIE_THICKNESS = 2;

WIDTH = SCREWS * (DISTANCE_X + cone_diameter(SCREW_DIAMETER)) + ZIP_TIES * (DISTANCE_X +
    ziptie_point_height(ZIP_TIE_THICKNESS)) + DISTANCE_X;
DEPTH = ziptie_point_height() > cone_diameter(SCREW_DIAMETER) ?
    (ziptie_point_height(ZIP_TIE_THICKNESS) + DISTANCE_Z * 2):(cone_diameter(SCREW_DIAMETER) + DISTANCE_Z * 2);

WIDTH_ZIPTIE_IN_MODEL = DISTANCE_X + ziptie_point_height(ZIP_TIE_THICKNESS);

module generate_elements(cutout = true) {
    elements = SCREWS + ZIP_TIES;

    for (i = [0:elements - 1]) {
        xPos_ziptie = DISTANCE_X + ziptie_point_height(ZIP_TIE_THICKNESS) / 2 + WIDTH_ZIPTIE_IN_MODEL * i +
            (round(ZIP_TIES / (SCREWS + 1)) < i ? (DISTANCE_X + cone_diameter(SCREW_DIAMETER) - WIDTH_ZIPTIE_IN_MODEL):0
            );

        one_screw = SCREWS == 1 && floor(elements / (SCREWS + 1)) == i;
        even_numbered_screws = SCREWS % 2 == 0 && i % round(elements / SCREWS - 1) == SCREWS;

        echo("1: ", one_screw, " even: ", even_numbered_screws);

        if (one_screw || even_numbered_screws) {
            translate([SCREW_DIAMETER + DISTANCE_X + (DISTANCE_X + ziptie_point_height(ZIP_TIE_THICKNESS)) * i,
                    DEPTH / 2, MATERIAL_THICKNESS])
                if (cutout) screw(SCREW_DIAMETER, MATERIAL_THICKNESS * 2, true);
        } else {
            translate([xPos_ziptie, DEPTH / 2, MATERIAL_THICKNESS]) rotate([90, 90, 90])
                ziptiepoint(ZIP_TIE_WIDTH, ZIP_TIE_THICKNESS, cutout);
        }
    }
}

union() {
    difference() {
        cube([WIDTH, DEPTH, MATERIAL_THICKNESS]);

        generate_elements(cutout = true);
    }
    generate_elements(cutout = false);
}

