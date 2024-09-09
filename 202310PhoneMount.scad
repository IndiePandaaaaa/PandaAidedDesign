// created by IndiePandaaaaa | Lukas

THICKNESS = 3.25;
TOLERANCE = 0.1;
CHAMFER = 1;
$fn = 75;

BOARD_THICKNESS = 20.8;
PHONE_THICKNESS = 12;
PHONE_ANGLE = 10;
HORIZONTAL = true; // for vertical mount set to false

// todo: add 3 degree angle to shrink the board for better stability when used
module phone_mount(board_thickness, phone_thickness, horizontal = true, phone_angle = 14, thickness = 3, chamfer = 1, tolerance = 0.1, pinch_angle = 2) {
    rotate([90, 0, 90]) difference() {
        linear_extrude(42) {
            pinch_offset = tan(pinch_angle) * board_thickness;
            angle_depth = board_thickness / tan(90 - phone_angle) + thickness;
            depth = thickness * 2 + tolerance * 2 + phone_thickness + board_thickness + angle_depth;
            height = thickness * 2 + board_thickness * 1.5;
            middle_point = thickness + phone_thickness + tolerance + angle_depth;

            A = [0, chamfer];
            B = [chamfer, 0];
            Ch = [depth, 0];
            Dh = [depth, thickness + pinch_offset];
            Eh = [middle_point, thickness];
            Fh = [middle_point, thickness + board_thickness + tolerance];
            Gh = [depth, Fh[1]];
            Cv = [middle_point, 0];
            Dv = Fh;
            Ev = [depth - thickness, thickness + board_thickness + tolerance];
            Fv = [depth - thickness - pinch_offset, 0];
            Gv = [depth, 0];
            H = [depth, thickness * 2 + board_thickness + tolerance - chamfer];
            I = [H[0] - chamfer, H[1] + chamfer];
            J = [depth * 0.8, thickness * 2 + board_thickness + tolerance];
            L = [(thickness + phone_thickness + tolerance) 
                  + (height - thickness) / tan(90 - phone_angle), height - chamfer];
            K = [L[0] + chamfer, height - thickness * sin(phone_angle)];
            M = [(thickness + phone_thickness + tolerance), thickness];
            N = [thickness + chamfer, thickness];
            O = [thickness, thickness + chamfer];
            P = [thickness + tan(phone_angle) * 5, thickness + 5];
            Q = [chamfer, thickness + 5];
            R = [0, thickness + 5 - chamfer];

            if (horizontal) {
                polygon([A, B, Ch, Dh, Eh, Fh, Gh, H, I, J, K, L, M, N, O, P, Q, R]);
            } else {
                polygon([A, B, Cv, Dv, Ev, Fv, Gv, H, I, J, K, L, M, N, O, P, Q, R]);
            }
        }
    }
}

phone_mount(BOARD_THICKNESS, PHONE_THICKNESS, HORIZONTAL, PHONE_ANGLE, THICKNESS, CHAMFER, TOLERANCE);
