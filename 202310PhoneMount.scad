// created by IndiePandaaaaa | Lukas

THICKNESS = 3.25;
TOLERANCE = 0.1;
CHAMFER = 1.5;
$fn = 75;

BOARD_THICKNESS = 21;
PHONE_THICKNESS = 12;
PHONE_ANGLE = 10;
HORIZONTAL = true; // for vertical mount set to false

// todo add vertical mount optinon
// todo add coords for vertical mount
module phone_mount(board_thickness, phone_thickness, horizontal = true, phone_angle = 14, thickness = 3, chamfer = 1,
tolerance = 0.1) {
    difference() {
        linear_extrude(50) {
            depth = thickness * 2 + tolerance * 2 + phone_thickness + board_thickness;
            height = thickness * 2 + board_thickness * 1.5;

            A = [0, chamfer];
            B = [chamfer, 0];
            Ch = [depth, 0];
            Cv = [];
            Dh = [depth, thickness];
            Dv = [];
            Eh = [depth * 0.55, thickness];
            Ev = [];
            Fh = [depth * 0.55, thickness + board_thickness + tolerance];
            Fv = [];
            Gh = [depth, thickness + board_thickness + tolerance];
            Gv = [];
            Hh = [depth, thickness * 2 + board_thickness + tolerance];
            Hv = [];
            I = [depth * 0.8, thickness * 2 + board_thickness + tolerance];
            J = [depth * 0.55 + (depth * 0.2) / tan(90 - phone_angle) + 2,
                                thickness * 2 + board_thickness + tolerance + depth * 0.2];
            K = [(thickness + phone_thickness + tolerance) + (height - thickness) / tan(90 - phone_angle) + thickness /
                cos(phone_angle), height - thickness * sin(phone_angle)];
            L = [(thickness + phone_thickness + tolerance) + (height - thickness) / tan(90 - phone_angle), height];
            M = [(thickness + phone_thickness + tolerance), thickness];
            N = [thickness + chamfer, thickness];
            O = [thickness, thickness + chamfer];
            P = [thickness + tan(phone_angle) * 5, thickness + 5];
            Q = [0, thickness + 5];

            if (horizontal) {
                polygon([A, B, Ch, Dh, Eh, Fh, Gh, Hh, I, J, K, L, M, N, O, P, Q]);
            } else {
                polygon([A, B, Ch, Dv, Ev, Fv, Gv, Hv, I, J, K, L, M, N, O, P, Q]);
            }
        }
    }
}

phone_mount(BOARD_THICKNESS, PHONE_THICKNESS, HORIZONTAL, PHONE_ANGLE, THICKNESS, CHAMFER, TOLERANCE);