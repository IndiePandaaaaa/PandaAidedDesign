// created by IndiePandaaaaa | Lukas

// REFERENCE: Goobay 3m Safety Plug Extension Cable

MODEL_TOLERANCE = 0.15;
MATERIAL_TICKNESS = 4.5;
CHAMFER = 1;

SCHUKO_SOCKET_WIDTH = 23;
SCHUKO_SOCKET_DEPTH = 38;
BOARD_THICKNESS = 20.8;
CABLE_OD = 9;

FULLWIDTH = MATERIAL_TICKNESS * 4 + MODEL_TOLERANCE + SCHUKO_SOCKET_WIDTH;
FULLDEPTH = MATERIAL_TICKNESS * 4 + MODEL_TOLERANCE * 2 + BOARD_THICKNESS + SCHUKO_SOCKET_DEPTH;
FULLHEIGHT = 16;

difference() {
    intersection() {
        rotate([90, 0, 90])
            linear_extrude(FULLWIDTH) {
                polygon([
                        [0, CHAMFER],
                        [CHAMFER, 0],
                        [MATERIAL_TICKNESS - CHAMFER, 0],
                        [MATERIAL_TICKNESS, CHAMFER],
                        [MATERIAL_TICKNESS, FULLHEIGHT - MATERIAL_TICKNESS],
                        [MATERIAL_TICKNESS + MODEL_TOLERANCE + BOARD_THICKNESS, FULLHEIGHT - MATERIAL_TICKNESS],
                        [MATERIAL_TICKNESS + MODEL_TOLERANCE + BOARD_THICKNESS, CHAMFER],
                        [MATERIAL_TICKNESS + MODEL_TOLERANCE + BOARD_THICKNESS + CHAMFER, 0],
                        [FULLDEPTH - CHAMFER, 0],
                        [FULLDEPTH, CHAMFER],
                        [FULLDEPTH, FULLHEIGHT - CHAMFER],
                        [FULLDEPTH - CHAMFER, FULLHEIGHT],
                        [CHAMFER, FULLHEIGHT],
                        [0, FULLHEIGHT - CHAMFER],
                    ]);
            }
        linear_extrude(FULLHEIGHT) {
            polygon([
                    [0, CHAMFER],
                    [CHAMFER, 0],
                    [FULLWIDTH - CHAMFER, 0],
                    [FULLWIDTH, CHAMFER],
                    [FULLWIDTH, FULLDEPTH - CHAMFER],
                    [FULLWIDTH - CHAMFER, FULLDEPTH],
                    [FULLWIDTH - (MATERIAL_TICKNESS * 2 + MODEL_TOLERANCE + SCHUKO_SOCKET_WIDTH / 2 - CABLE_OD / 2) +
                    CHAMFER, FULLDEPTH],
                    [FULLWIDTH - MATERIAL_TICKNESS * 2 - MODEL_TOLERANCE - SCHUKO_SOCKET_WIDTH / 2 + CABLE_OD / 2,
                        FULLDEPTH - CHAMFER],
                    [FULLWIDTH - MATERIAL_TICKNESS * 2 - MODEL_TOLERANCE - SCHUKO_SOCKET_WIDTH / 2 + CABLE_OD / 2,
                        FULLDEPTH - MATERIAL_TICKNESS * 2],
                    [FULLWIDTH - MATERIAL_TICKNESS * 2, FULLDEPTH - MATERIAL_TICKNESS * 2],
                    [FULLWIDTH - MATERIAL_TICKNESS * 2, FULLDEPTH - MATERIAL_TICKNESS * 2 - SCHUKO_SOCKET_DEPTH -
                    MODEL_TOLERANCE],
                    [MATERIAL_TICKNESS * 2, FULLDEPTH - MATERIAL_TICKNESS * 2 - SCHUKO_SOCKET_DEPTH - MODEL_TOLERANCE],
                    [MATERIAL_TICKNESS * 2, FULLDEPTH - MATERIAL_TICKNESS * 2],
                    [MATERIAL_TICKNESS * 2 + MODEL_TOLERANCE + SCHUKO_SOCKET_WIDTH / 2 - CABLE_OD / 2, FULLDEPTH -
                        MATERIAL_TICKNESS * 2],
                    [MATERIAL_TICKNESS * 2 + MODEL_TOLERANCE + SCHUKO_SOCKET_WIDTH / 2 - CABLE_OD / 2, FULLDEPTH -
                    CHAMFER],
                    [MATERIAL_TICKNESS * 2 + MODEL_TOLERANCE + SCHUKO_SOCKET_WIDTH / 2 - CABLE_OD / 2 - CHAMFER,
                    FULLDEPTH],
                    [CHAMFER, FULLDEPTH],
                    [0, FULLDEPTH - CHAMFER],
                ]);
        }
        rotate([- 90, 0, 0]) translate([0, - FULLHEIGHT, 0])
            linear_extrude(FULLDEPTH) {
                polygon([
                        [0, CHAMFER],
                        [CHAMFER, 0],
                        [FULLWIDTH - CHAMFER, 0],
                        [FULLWIDTH, CHAMFER],
                        [FULLWIDTH, FULLHEIGHT - CHAMFER],
                        [FULLWIDTH - CHAMFER, FULLHEIGHT],
                        [CHAMFER, FULLHEIGHT],
                        [0, FULLHEIGHT - CHAMFER],
                    ]);
            }
    }
    translate([(FULLWIDTH - (5 * 2 + MODEL_TOLERANCE + SCHUKO_SOCKET_WIDTH)) / 2, FULLDEPTH -
            MATERIAL_TICKNESS * 2, FULLHEIGHT - 2.5]) rotate([90, 0, 0])
        linear_extrude(SCHUKO_SOCKET_DEPTH + MODEL_TOLERANCE) {
            polygon([
                    [0, 2.5],
                    [5, 0],
                    [5 + MODEL_TOLERANCE + SCHUKO_SOCKET_WIDTH, 0],
                    [5 * 2 + MODEL_TOLERANCE + SCHUKO_SOCKET_WIDTH, 2.5],
                ]);
        }
}

