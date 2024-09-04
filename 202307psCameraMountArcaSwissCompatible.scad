// created by IndiePandaaaaa | Lukas

use <Parts/ArcaSwiss.scad>
use <Variables/Threading.scad>

CAM_TOLERANCE = 0.1;

PSCAMERA_OUTER_DIAMETER = 28;
PSCAMERA_HEIGHT_OFFSET = 2;  // has to be more than -5

SOCKET_DEPTH = 42;
SOCKET_CAMERA_WIDTH = PSCAMERA_OUTER_DIAMETER + 3;
SOCKET_SLOPE_HEIGHT = PSCAMERA_HEIGHT_OFFSET + 7;

WITH_CAP = 0;  // 1 for model with top bracket / cap

MIC_DISTANCE = 27;
MIC_DIAMETER = 5;

ZT_X_OFFSET = 1.1;

FN = 150;

SOCKET_DEPTH_GAP = (as_width() - SOCKET_CAMERA_WIDTH) / 2;

module zt_ring(zt_width = 2.5, zt_height = 1) {// zt -> zip tie
    offset = .5;
    rotate_extrude($fn = FN) {
        x_dist = (SOCKET_CAMERA_WIDTH) / 2;
        polygon([
                [x_dist - offset + 0, offset / 2],
                [x_dist - offset + 0, offset / 2 + zt_width],
                [x_dist - offset + (zt_height + offset) / 2, offset + zt_width],
                [x_dist - offset + zt_height + offset, offset / 2 + zt_width],
                [x_dist - offset + zt_height + offset, offset / 2],
                [x_dist - offset + (zt_height + offset) / 2, 0],
            ]);
    }
}

difference() {
    union() {
        arca_swiss(SOCKET_DEPTH);
        translate([SOCKET_DEPTH_GAP, as_height() + PSCAMERA_HEIGHT_OFFSET, 0])
            cube([SOCKET_CAMERA_WIDTH, PSCAMERA_OUTER_DIAMETER / 2, SOCKET_DEPTH]);
        if (WITH_CAP == 1) {
            translate([as_width() / 2, as_height() + PSCAMERA_OUTER_DIAMETER / 2 + PSCAMERA_HEIGHT_OFFSET, 0])
                cylinder(d = SOCKET_CAMERA_WIDTH, h = SOCKET_DEPTH, $fn = FN);
        }
        translate([0, as_height(), 0]) {
            linear_extrude(SOCKET_DEPTH) {
                polygon([
                        [0, 0],
                        [SOCKET_DEPTH_GAP, 0],
                        [SOCKET_DEPTH_GAP, SOCKET_SLOPE_HEIGHT],
                    ]);
                polygon([
                        [as_width(), 0],
                        [as_width() - SOCKET_DEPTH_GAP, 0],
                        [as_width() - SOCKET_DEPTH_GAP, SOCKET_SLOPE_HEIGHT],
                    ]);
            }
        }
        if (PSCAMERA_HEIGHT_OFFSET > 0) {
            translate([SOCKET_DEPTH_GAP, as_height(), 0])
                cube([SOCKET_CAMERA_WIDTH, PSCAMERA_HEIGHT_OFFSET, SOCKET_DEPTH]);
        }
    }
    translate([as_width() / 2, as_height() + PSCAMERA_OUTER_DIAMETER / 2 + PSCAMERA_HEIGHT_OFFSET, 0])
        cylinder(d = PSCAMERA_OUTER_DIAMETER + CAM_TOLERANCE, h = SOCKET_DEPTH, $fn = FN);
    translate([as_width() / 2, 0, SOCKET_DEPTH / 2])
        rotate([270, 0, 0]) cylinder(d = core_hole_UNC14(), h = as_height() + 1 + PSCAMERA_HEIGHT_OFFSET, $fn = FN);

    if (WITH_CAP == 1)
        translate([0, as_height() + SOCKET_SLOPE_HEIGHT, 0])
            cube([as_width() / 3, PSCAMERA_OUTER_DIAMETER / 3 * 2, SOCKET_DEPTH]);
    if (WITH_CAP != 1)
        translate([0, as_height() + SOCKET_SLOPE_HEIGHT, 0])
            cube([as_width(), PSCAMERA_OUTER_DIAMETER / 3 * 2, SOCKET_DEPTH]);


    for (i = [0:1]) {
        translate([as_width() / 2, as_height() + PSCAMERA_OUTER_DIAMETER / 2 + PSCAMERA_HEIGHT_OFFSET,
                ZT_X_OFFSET + (SOCKET_DEPTH - ZT_X_OFFSET * 2 - 3) * i]) zt_ring();

        if (WITH_CAP == 1) {
            rotate([0, 90, 0])
                translate([- (SOCKET_DEPTH - (MIC_DISTANCE)) / 2 - MIC_DISTANCE * i,
                            as_height() + PSCAMERA_OUTER_DIAMETER / 2 + PSCAMERA_HEIGHT_OFFSET, SOCKET_CAMERA_WIDTH])
                    cylinder(d = MIC_DIAMETER, h = 7, $fn = FN);
        }
    }
}