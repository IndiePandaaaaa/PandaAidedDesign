// created by IndiePandaaaaa | Lukas

THICKNESS = 3.25;
TOLERANCE = 0.1;
CHAMFER = 1.5;
$fn = 75;

DESK_THICKNESS = 21;
PHONE_THICKNESS = 12;
PHONE_ANGLE = 10;

module phone_mount(desk_thickness, phone_thickness, phone_angle = 14, thickness = 3, chamfer = 1, tolerance = 0.1) {
    linear_extrude(50) {
        depth = desk_thickness * 2;
        height = desk_thickness * 2;
        slope_angle = 30;
        polygon([
                [chamfer, 0],
                [depth, 0],
                [depth, thickness],
                [depth * 0.55, thickness],
                [depth * 0.55, thickness + desk_thickness + tolerance],
                [depth, thickness + desk_thickness + tolerance],
                [depth, thickness * 2 + desk_thickness + tolerance],
                [depth * 0.8, thickness * 2 + desk_thickness + tolerance],
                [depth * 0.55 + (depth * 0.2) / tan(90 - phone_angle),
                                thickness * 2 + desk_thickness + tolerance + depth * 0.2],
                [(thickness + phone_thickness + tolerance) + (height - thickness) / tan(90 - phone_angle)
                + thickness / cos(phone_angle), height - thickness * sin(phone_angle)],
                [(thickness + phone_thickness + tolerance) + (height - thickness) / tan(90 - phone_angle), height],
                [(thickness + phone_thickness + tolerance), thickness],
                [thickness + chamfer, thickness],
                [thickness, thickness + chamfer],
                [thickness + tan(phone_angle) * 5, thickness + 5],
                [0, thickness + 5],
                [0, chamfer],
            ]);
    }
}

phone_mount(DESK_THICKNESS, PHONE_THICKNESS, PHONE_ANGLE, THICKNESS, CHAMFER, TOLERANCE);