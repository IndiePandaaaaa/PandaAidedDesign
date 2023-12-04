// created by IndiePandaaaaa|Lukas



TOLERANCE = 0.1;
MATERIAL_THICKNESS = 3.5;

module lamp_adapter(od, outer_length) {
    rotate_extrude() {
        polygon([
                [0,0],
            [od/2, 0],
            ]);
    }
}