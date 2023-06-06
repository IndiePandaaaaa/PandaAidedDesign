// created by IndiePandaaaaa | Lukas

use <Parts/Screw.scad>
use <Parts/ZipTiePoint.scad>

MODEL_TOLERANCE = 0.15;
MATERIAL_THICKNESS = 2.5;
DISTANCE_X = 2;
DISTANCE_Z = DISTANCE_X;

SCREWS = 1;
SCREW_DIAMETER = 3.5;

ZIP_TIES = 3;
ZIP_TIE_WIDTH = 2.5;
ZIP_TIE_THICKNESS = 2;

WIDTH = SCREWS * (DISTANCE_X + cone_diameter(SCREW_DIAMETER)) + ZIP_TIES * (DISTANCE_X +
    ziptie_point_height(ZIP_TIE_THICKNESS)) + DISTANCE_X;
DEPTH = ziptie_point_height() > cone_diameter(SCREW_DIAMETER) ?
    (ziptie_point_height(ZIP_TIE_THICKNESS) + DISTANCE_Z * 2):(cone_diameter(SCREW_DIAMETER) + DISTANCE_Z * 2);

module one_screw(cutout = true) {
    for (i = [0:SCREWS + ZIP_TIES - 1]) {
        if (round(ZIP_TIES / 2) == i) {
            translate([SCREW_DIAMETER + DISTANCE_X + (DISTANCE_X + ziptie_point_height(ZIP_TIE_THICKNESS)) * i,
                    DEPTH / 2, MATERIAL_THICKNESS])
                if (cutout) screw(SCREW_DIAMETER, MATERIAL_THICKNESS * 2, true);
        } else {
            width_zip_tie = DISTANCE_X + ziptie_point_height(ZIP_TIE_THICKNESS);
            xPos = DISTANCE_X + ziptie_point_height(ZIP_TIE_THICKNESS) / 2 + width_zip_tie * i + (round(ZIP_TIES / 2) <
            i ? (DISTANCE_X + cone_diameter(SCREW_DIAMETER) - width_zip_tie) : 0);
            translate([xPos, DEPTH / 2, MATERIAL_THICKNESS])
                rotate([90, 90, 90])
                    ziptiepoint(ZIP_TIE_WIDTH, ZIP_TIE_THICKNESS, cutout);
        }
    }
}

union() {
    difference() {
        cube([WIDTH, DEPTH, MATERIAL_THICKNESS]);

        if (SCREWS == 1) one_screw(cutout = true);
    }
    if (SCREWS == 1) one_screw(cutout = false);
}

