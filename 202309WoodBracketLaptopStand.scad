// created by IndiePandaaaaa|Lukas

use <Parts/Screw.scad>
use <Variables/Threading.scad>
use <202306lBracket.scad>

TOLERANCE = 0.2;
THICKNESS = 3;
SCREW_OD = 3.5;
SCREW_SOCKET = SCREW_OD * 2 * 1.5;
$fn = 50;

WOOD_WIDTH = 42;
WOOD_DEPTH = 24;

ANGLE = 60;

// ---

TOP_THREADING_HOLES = false;

// --------------

AB = WOOD_DEPTH;
CD = THICKNESS;
EF = SCREW_SOCKET;  // SCSO
FG = THICKNESS;
JC = EF;
DI = JC;
// -----
IE = cos(ANGLE) * EF;
IF = sin(ANGLE) * EF;
DE = EF + IE;
EN = CD / tan(ANGLE);
BJ = IE + EN;
BC = EF + BJ;
FM = cos(ANGLE) * FG;
MG = sqrt(pow(FG, 2) - pow(FM, 2));
AH = FG + cos(ANGLE) * AB;
AO = sin(ANGLE) * AH;
HO = sqrt(pow(AH, 2) - pow(AO, 2));
GH = sin(ANGLE) * AB + CD / sin(ANGLE) + EF;

shape = [
        [0, BC], // A
        [AB, BC], // B
        [AB, 0], // C
        [AB + CD, 0], // D
        [AB + CD, DE], // E
        [AB + CD + IF, DI], // F
        [AB + CD + IF + FM, DI + MG], // G
        [HO, BC + AO], // H
    ];

H_3D = [HO, BC + AO, 0];

function get_shape() = shape;

module M4_sockets(GH, WOOD_WIDTH, cutout = false) {
    height = 12;
    m4_socket = 6.5;
    for (x = [0:1]) {
        for (z = [0:1]) {
            translate([GH / 5 + GH / 5 * 3 * x, height, WOOD_WIDTH / 5 + WOOD_WIDTH / 5 * 3 * z]) {
                rotate([90, 0, 0]) {
                    difference() {
                        cylinder(h = height, d = m4_socket);
                        if (TOP_THREADING_HOLES) {
                            cylinder(h = height, d = core_hole_M4());
                        }
                    }
                    if (cutout)
                        cylinder(h = height + 2, d = core_hole_M4());
                }
            }
        }
    }
}

module angled_bracket(angle, wood_depth, wood_width, screw_socket, thickness, GH, H) {
    difference() {
        linear_extrude(WOOD_WIDTH) {
            polygon([
                    [0, BC], // A
                    [AB, BC], // B
                    [AB, 0], // C
                    [AB + CD, 0], // D
                    [AB + CD, DE], // E
                    [AB + CD + IF, DI], // F
                    [AB + CD + IF + FM, DI + MG], // G
                    [HO, BC + AO], // H
                ]);
        }

        translate([WOOD_DEPTH - SCREW_OD * 1.5, BC + THICKNESS * 1.5, WOOD_WIDTH / 2]) rotate([- 90, 0, 0]) {
            if (TOP_THREADING_HOLES) {
                screw(SCREW_OD, WOOD_WIDTH, true);
                cylinder(h = WOOD_WIDTH, d = cone_diameter_cutout(SCREW_OD));
            } else {
                translate([0, 0, - WOOD_WIDTH / 2]) cylinder(h = WOOD_WIDTH, d = SCREW_OD + 1);
            }
        }
        for (i = [0:1]) {
            translate([WOOD_DEPTH + THICKNESS, SCREW_SOCKET / 2, WOOD_WIDTH / 4 + WOOD_WIDTH / 2 * i])
                rotate([0, 90, 0]) screw(SCREW_OD, 20, true);
        }
        if (TOP_THREADING_HOLES) {
            translate(H) rotate([0, 0, - 90 + angle]) M4_sockets(GH, WOOD_WIDTH, true);
        }
    }
    translate(H) rotate([0, 0, - 90 + angle]) M4_sockets(GH, WOOD_WIDTH, false);
}

angled_bracket(ANGLE, WOOD_DEPTH, WOOD_WIDTH, SCREW_SOCKET, THICKNESS, GH, H_3D);

// drilling helper
translate([50, WOOD_DEPTH, 0]) {
    union() {
        translate([- THICKNESS - TOLERANCE, - WOOD_DEPTH, 0]) cube([THICKNESS, WOOD_DEPTH + THICKNESS,
            WOOD_WIDTH]);
        translate([- TOLERANCE * 2, 0, 0]) cube([THICKNESS, THICKNESS, WOOD_WIDTH]);
        difference() {
            cube([GH, THICKNESS, WOOD_WIDTH]);
            M4_sockets(GH, WOOD_WIDTH, true);
        }
    }
}

// laptop fixture
translate([100, 0, 0]) {
    difference() {
        cube([WOOD_DEPTH + 15, THICKNESS, WOOD_WIDTH]);
        for (i = [0:1]) {
            translate([WOOD_DEPTH / 2, THICKNESS, WOOD_WIDTH / 4 + WOOD_WIDTH / 2 * i])
                rotate([- 90, 0, 0]) screw(SCREW_OD, 20, true);
        }
    }
}

// LBracket
translate([150, 0, 0]) {
    LBracket(3, WOOD_WIDTH);
}

// stabilizer bracket
translate([200, 0, 0]) {
    difference() {
        SCREW_SOCKET_5 = 5 * 2 * 1.5;
        union() {
            cube([WOOD_WIDTH * 2 + THICKNESS, THICKNESS, SCREW_SOCKET_5]);
            cube([THICKNESS, WOOD_WIDTH / 2 + SCREW_SOCKET_5 / 2, SCREW_SOCKET_5]);
        }
        translate([0, 0, SCREW_SOCKET_5 / 2]) {
            rotate([90, 0, 0]) {
                translate([THICKNESS + WOOD_WIDTH / 2, 0, 0]) screw(SCREW_OD, 16, true);
                for (i = [0:1]) {
                    translate([THICKNESS + WOOD_WIDTH + WOOD_WIDTH / 4 + WOOD_WIDTH / 2 * i, 0, 0]) screw(SCREW_OD, 16,
                    true
                    );
                }
            }
            rotate([0, - 90, 0]) translate([0, WOOD_WIDTH / 2, 0]) screw(5, 70, true);
        }
    }
}
