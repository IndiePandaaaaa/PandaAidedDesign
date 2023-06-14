// created by IndiePandaaaaa | Lukas

use <Parts/Screw.scad>
use <Parts/ZipTiePoint.scad>

MODEL_TOLERANCE = 0.15;
MATERIAL_THICKNESS = 2.5;
DISTANCE_X = 2;
DISTANCE_Z = DISTANCE_X;

ZIP_TIES = 8;
ZIP_TIE_WIDTH = 2.5;
ZIP_TIE_THICKNESS = 2;

SCREW_DIAMETER = 3.5;

DEPTH = ziptie_point_height() > cone_diameter(SCREW_DIAMETER) ?
    (ziptie_point_height(ZIP_TIE_THICKNESS) + DISTANCE_Z * 2):(cone_diameter(SCREW_DIAMETER) + DISTANCE_Z * 2);

WIDTH_ZIPTIE_IN_MODEL = DISTANCE_X + ziptie_point_height(ZIP_TIE_THICKNESS);

module generate_elements(screws, cutout = true) {
    elements = screws + ZIP_TIES;

    for (i = [0:elements - 1]) {
        xPos_ziptie = DISTANCE_X + ziptie_point_height(ZIP_TIE_THICKNESS) / 2 + WIDTH_ZIPTIE_IN_MODEL * i +
            (
                round(ZIP_TIES / (screws + 1)) < i ?
                (DISTANCE_X + cone_diameter(SCREW_DIAMETER) - WIDTH_ZIPTIE_IN_MODEL):0
            );

        //even_numbered_screws = SCREWS % 2 == 0 && i % round(elements / SCREWS - 1) == SCREWS;

        one_screw = screws == 1 && ZIP_TIES <= 4 && floor(elements / (screws + 1)) == i;

        two_screws = screws == 2 && ZIP_TIES <= 7 && (
        (ZIP_TIES == 3 && (i == 0 || i == elements - 1)) ||
        (3 < ZIP_TIES && ZIP_TIES <= 5 && (i == 1 || i == ZIP_TIES)) ||
        (5 < ZIP_TIES && ZIP_TIES <= 7 && (i == 2 || i == ZIP_TIES))
        );

        three_screws = screws == 3 && ZIP_TIES <= 10 && (
        (1 < ZIP_TIES && ZIP_TIES <= 5 && (i == 0 || i == round((elements - 1) / 2) || i == elements - 1)) ||
        (5 < ZIP_TIES && ZIP_TIES <= 8 && (i == 1 || i == round((elements - 1) / 2) || i == elements - 2))
        );

        four_screws = screws == 4 && ZIP_TIES <= 13;

        five_screws = screws == 5 && ZIP_TIES <= 16;

        if (one_screw || two_screws || three_screws || four_screws || five_screws) {
            translate([SCREW_DIAMETER + DISTANCE_X + (DISTANCE_X + ziptie_point_height(ZIP_TIE_THICKNESS)) * i,
                    DEPTH / 2, MATERIAL_THICKNESS])
                if (cutout) screw(SCREW_DIAMETER, MATERIAL_THICKNESS * 2, true);
        } else {
            translate([xPos_ziptie, DEPTH / 2, MATERIAL_THICKNESS]) rotate([90, 90, 90])
                ziptiepoint(ZIP_TIE_WIDTH, ZIP_TIE_THICKNESS, cutout);
        }
    }
}

for (screws = [0:5]) {
    width = screws * (DISTANCE_X + cone_diameter(SCREW_DIAMETER)) + ZIP_TIES * (DISTANCE_X +
        ziptie_point_height(ZIP_TIE_THICKNESS)) + DISTANCE_X;

    is_valid =
    (screws == 0) ||
    (screws == 1 && ZIP_TIES <= 4) ||
    (screws == 2 && ZIP_TIES <= 7) ||
    (screws == 3 && ZIP_TIES <= 10) ||
    (screws == 4 && ZIP_TIES <= 13) ||
    (screws == 5 && ZIP_TIES <= 16);

    if (is_valid) {
        translate([0, DEPTH * 1.5 * screws, 0]) {
            union() {
                difference() {
                    cube([width, DEPTH, MATERIAL_THICKNESS]);

                    generate_elements(screws, cutout = true);
                }
                generate_elements(screws, cutout = false);
            }
        }
    }
}

