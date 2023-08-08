// created by IndiePandaaaaa | Lukas

use <../Variables/Threading.scad>

HEIGHT = 8;
OFFSET = 6;
OFFSET_SCREWS = 12;

FN = 100;

difference() {
    cube([OFFSET * 2 + OFFSET_SCREWS, OFFSET * 2 + OFFSET_SCREWS * 2, HEIGHT-0.1]);

    for (i = [0:2]) {
        translate([OFFSET, OFFSET + OFFSET_SCREWS * i, 0]) {
            cylinder(d = core_hole_UNC14(), h = HEIGHT, $fn = FN);
            translate([OFFSET_SCREWS, 0, 0]) cylinder(d = core_hole_UNC38(), h = HEIGHT, $fn = FN);
        }
    }
}