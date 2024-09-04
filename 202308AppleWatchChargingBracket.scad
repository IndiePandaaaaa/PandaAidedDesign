// created by IndiePandaaaaa|Lukas

use <Parts/ZipTiePoint.scad>

MATERIAL_THICKNESS = 2.5;
TOLERANCE = 0.2;
FN = $preview ? 25 : 120;

STAND_DIAMETER = 25.3;  // diameter from elgato multimount

BRACKET_HEIGHT = 10;
BRACKET_WIDTH = STAND_DIAMETER * 1.5;
BRACKET_DEPTH = STAND_DIAMETER * 2;

PAD_DIAMETER = 27.6; // charging pad for apple watch
PAD_THICKNESS = 6;
PAD_ANGLE = 60;
PAD_OFFSET = 42; // offset from the stand
PAD_CABLE_DIAMETER = 3;

ZT_WIDTH = 2.5; // zip tie width

width = PAD_OFFSET - PAD_OFFSET / 2 + BRACKET_WIDTH;
height = PAD_DIAMETER * 1.1;
thickness = PAD_THICKNESS * 1.25;

module apple_watch_pad_dummy() {
    cylinder(d = PAD_DIAMETER + TOLERANCE, PAD_THICKNESS, $fn = FN);
}
module apple_watch_pad_cable_dummy() {
    cube([PAD_OFFSET * 2, PAD_CABLE_DIAMETER + TOLERANCE, PAD_THICKNESS]);
}

module cable_bend_radius(rad = 20) {
    translate([BRACKET_WIDTH - rad / 2, 0, 0]) rotate([0, PAD_ANGLE - 90, 270])
        translate([- rad / 2 + (thickness - (PAD_THICKNESS - 0.5)), 0, height / 4 - (PAD_CABLE_DIAMETER + TOLERANCE) / 2
            ])
            difference() {
                cube([rad / 2, rad / 2, PAD_CABLE_DIAMETER + TOLERANCE]);
                cylinder(d = rad, PAD_CABLE_DIAMETER + TOLERANCE, $fn = FN);
            }
}

difference() {
    linear_extrude(BRACKET_HEIGHT) {
        difference() {
            polygon([
                    [0, 0],
                    [BRACKET_WIDTH, 0],
                    [BRACKET_WIDTH, BRACKET_DEPTH / 2],
                    [BRACKET_WIDTH / 6 * 5.5, BRACKET_DEPTH],
                    [BRACKET_WIDTH / 6 * 4.95, BRACKET_DEPTH],
                    [BRACKET_WIDTH / 6 * 4.95, BRACKET_DEPTH / 3 * 2],
                    [BRACKET_WIDTH / 6 * 1.05, BRACKET_DEPTH / 3 * 2],
                    [BRACKET_WIDTH / 6 * 1.05, BRACKET_DEPTH],
                    [BRACKET_WIDTH / 6 * 0.5, BRACKET_DEPTH],
                    [0, BRACKET_DEPTH / 2],
                ]);
            translate([BRACKET_WIDTH / 2, BRACKET_DEPTH / 1.5])
                circle(d = STAND_DIAMETER + TOLERANCE, $fn = FN);
        }
    }
    rotate([PAD_ANGLE, 0, 0])
        cube([BRACKET_WIDTH, BRACKET_HEIGHT * 2, 5]);
    translate([0, BRACKET_DEPTH - ZT_WIDTH, BRACKET_HEIGHT / 2])
        rotate([0, 90, 0])
            cylinder(d = ZT_WIDTH + 0.25, h = BRACKET_WIDTH, $fn = FN);
    cable_bend_radius(14);

    angle = atan((BRACKET_WIDTH / 6 * 0.5) / (BRACKET_DEPTH / 2));
    width_offset = tan(angle) * BRACKET_DEPTH / 4 - TOLERANCE;
    translate([BRACKET_WIDTH - width_offset, BRACKET_DEPTH / 4 * 3, BRACKET_HEIGHT / 2])
        rotate([90, 180, angle]) {
            ziptiepoint(cutout = true);
        }
}
difference() {
    union() translate([- PAD_OFFSET / 2, 0, 0]) {
        rotate([PAD_ANGLE, 0, 0]) {
            difference() {
                translate([0, 0, 0]) cube([width, height / 2, thickness]);
                translate([0, height / 4, thickness - (PAD_THICKNESS - 0.5)]) apple_watch_pad_dummy();
                translate([0, height / 4 - (PAD_CABLE_DIAMETER + TOLERANCE) / 2, thickness - (PAD_THICKNESS - 0.5)])
                    apple_watch_pad_cable_dummy();
            }
            difference() {
                translate([0, height / 4, 0]) cylinder(d = height, h = thickness, $fn = FN);
                translate([0, height / 4, thickness - (PAD_THICKNESS - 0.5)]) apple_watch_pad_dummy();
                translate([0, height / 4 - (PAD_CABLE_DIAMETER + TOLERANCE) / 2, thickness - (PAD_THICKNESS - 0.5)])
                    apple_watch_pad_cable_dummy();
            }
        }
    }
    cable_bend_radius(14);
}

angle = atan((BRACKET_WIDTH / 6 * 0.5) / (BRACKET_DEPTH / 2));
width_offset = tan(angle) * BRACKET_DEPTH / 4;
translate([BRACKET_WIDTH - width_offset, BRACKET_DEPTH / 4 * 3, BRACKET_HEIGHT / 2])
    rotate([90, 180, angle]) {
        ziptiepoint(cutout = false);
    }






