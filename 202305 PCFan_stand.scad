// created by IndiePandaaaaa

use <Parts/Screw.scad>
use <Structures/Hexagon.scad>

MODEL_TOLERANCE = 0.15;
MATERIAL_THICKNESS = 3.5;

// DIAMETER -> DISTANCE: 140 -> 125 | 120 -> 105 | 80 -> 71.5
FAN_SCREW_DISTANCE = 105;
FAN_DIAMETER = 120;
FAN_DEPTH = 25;

STAND_DEPTH = FAN_DEPTH / 2 * 3;
FRONT_OVERHANG = FAN_DEPTH / 5 * 0;

SCREW_OFFSET = (FAN_DIAMETER - FAN_SCREW_DISTANCE) / 2;
SCREW_DIAMETER = 5.2; // the hole in the fan has the diameter 4.3 mm
HEIGHT_FROM_FLOOR = 5;

M3_HOLE = 2.5; // see https://de.wikipedia.org/wiki/Kernloch for more information

difference() {
    rotate([90, 0, 90])
        linear_extrude(height = FAN_DIAMETER) {
            polygon([
                    [0, 0],
                    [STAND_DEPTH, 0],
                    [STAND_DEPTH, MATERIAL_THICKNESS],
                    [MATERIAL_THICKNESS + FRONT_OVERHANG, MATERIAL_THICKNESS],
                    [MATERIAL_THICKNESS + FRONT_OVERHANG, MATERIAL_THICKNESS + SCREW_OFFSET * 2 + HEIGHT_FROM_FLOOR],
                    [FRONT_OVERHANG, MATERIAL_THICKNESS + SCREW_OFFSET * 2 + HEIGHT_FROM_FLOOR],
                    [FRONT_OVERHANG, MATERIAL_THICKNESS],
                    [0, MATERIAL_THICKNESS],
                ]);
        }/*
    translate([FAN_DIAMETER / 2, FAN_DEPTH + 0.01, FAN_DIAMETER / 2 + MATERIAL_THICKNESS + HEIGHT_FROM_FLOOR])
        rotate([90, 0, 0])
            cylinder(h = FAN_DEPTH + 0.02, d = FAN_DIAMETER, $fa = 1);*/

    for (i = [0:1]) {
        translate([SCREW_OFFSET + FAN_SCREW_DISTANCE * i, FRONT_OVERHANG / 2 - 0.01 - MATERIAL_THICKNESS / 2,
                    MATERIAL_THICKNESS + HEIGHT_FROM_FLOOR + SCREW_OFFSET])
            rotate([90, 0, 0]) screw(SCREW_DIAMETER, FAN_DEPTH + 0.02, true);

        translate([SCREW_OFFSET + FAN_SCREW_DISTANCE * i, FRONT_OVERHANG + MATERIAL_THICKNESS + M3_HOLE, - 0.01])
            cylinder(h = MATERIAL_THICKNESS + 0.02, d = M3_HOLE, $fn = 100);
    }

    HEX_OD = FAN_DEPTH - (FAN_DEPTH / 5) - MATERIAL_THICKNESS - 3;
    usable_depth = STAND_DEPTH - FRONT_OVERHANG - MATERIAL_THICKNESS - 3;
    usable_width = FAN_DIAMETER - 4;
    translate([(FAN_DIAMETER - hexagon_get_used_width(usable_width, HEX_OD)) / 2,
                FRONT_OVERHANG + MATERIAL_THICKNESS + (HEX_OD - hexagon_get_used_width(usable_depth, HEX_OD)) / 2, 0])
        rotate([180, 0, 0])
            translate([0, - FRONT_OVERHANG - MATERIAL_THICKNESS - 2 - usable_depth, - MATERIAL_THICKNESS])
                hexagon_pattern(usable_width, usable_depth, MATERIAL_THICKNESS, HEX_OD);
}