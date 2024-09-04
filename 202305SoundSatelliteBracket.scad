// created by IndiePandaaaaa | Lukas

// Sound Satelite for Reference: Wavemaster MX3

MODEL_TOLERANCE = 0.1;
MATERIAL_THICKNESS = 2.5;
CHAMFER = 1;
FN = $preview ? 25 : 120;

OD_TRIPOD = 25;
SATELLITE_TRIPOD_OFFSET = 12;
CABLETIE_WIDTH = 3;
SCREW_KERNLOCH = 3.3; // SETTINGS FOR M4

FULLDEPTH = SATELLITE_TRIPOD_OFFSET + OD_TRIPOD + MODEL_TOLERANCE + MATERIAL_THICKNESS + CABLETIE_WIDTH;
FULLWIDTH = OD_TRIPOD + MATERIAL_THICKNESS * 2 + MODEL_TOLERANCE;
FULLHEIGHT = 21;

difference() {
    linear_extrude(FULLHEIGHT) {
        polygon([
                [0, 0],
                [FULLWIDTH, 0],
                [FULLWIDTH, FULLDEPTH - CHAMFER],
                [FULLWIDTH - CHAMFER, FULLDEPTH],
                [FULLWIDTH - CABLETIE_WIDTH * 2 + CHAMFER, FULLDEPTH],
                [FULLWIDTH - CABLETIE_WIDTH * 2, FULLDEPTH - CHAMFER],
                [FULLWIDTH - CABLETIE_WIDTH * 2, FULLDEPTH / 2],
                [CABLETIE_WIDTH * 2, FULLDEPTH / 2],
                [CABLETIE_WIDTH * 2, FULLDEPTH - CHAMFER],
                [CABLETIE_WIDTH * 2 - CHAMFER, FULLDEPTH],
                [CHAMFER, FULLDEPTH],
                [0, FULLDEPTH - CHAMFER],
            ]);
    }

    translate([(OD_TRIPOD + MODEL_TOLERANCE) / 2 + MATERIAL_THICKNESS, (OD_TRIPOD + MODEL_TOLERANCE) / 2 +
        MATERIAL_THICKNESS + SATELLITE_TRIPOD_OFFSET, - FULLHEIGHT / 2])
        cylinder(h = FULLHEIGHT * 2, d = OD_TRIPOD + MODEL_TOLERANCE, $fn = FN);

    translate([FULLWIDTH / 2, - 0.01, FULLHEIGHT / 4 * 3])rotate([- 90, 0, 0])
        cylinder(h = OD_TRIPOD / 2 + SATELLITE_TRIPOD_OFFSET, d = SCREW_KERNLOCH, $fn = FN);

    for (i = [0:1]) {
        translate([- 0.01, FULLDEPTH - CABLETIE_WIDTH - CHAMFER, FULLHEIGHT / 4 + FULLHEIGHT / 2 * i])
            rotate([0, 90, 0])
                cylinder(h = FULLWIDTH + 0.02, d = CABLETIE_WIDTH, $fn = FN);
    }
}
