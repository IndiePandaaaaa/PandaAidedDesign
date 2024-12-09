// created by IndiePandaaaaa

use <Parts/Screw.scad>
use <Structures/Hexagon.scad>
use <Variables/Threading.scad>

MODEL_TOLERANCE = 0.15;
MATERIAL_THICKNESS = 3.5;
$fn = 125;

module fan_stand(FAN_DIAMETER, FAN_SCREW_DISTANCE, FAN_DEPTH = 25) {
  STAND_DEPTH = FAN_DEPTH / 2 * 3;
  FRONT_OVERHANG = FAN_DEPTH / 5 * 0; // optionally

  SCREW_OFFSET = (FAN_DIAMETER - FAN_SCREW_DISTANCE) / 2;
  SCREW_DIAMETER = 5.2; // the hole in the fan has the diameter 4.3 mm
  HEIGHT_FROM_FLOOR = 5;

  M3_HOLE = core_hole_M3();
  UNC14_HOLE = core_hole_UNC14();

  UNC14_EDGE_OFFSET = 1.5;

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
      }

    // front fan cutout
    translate([FAN_DIAMETER / 2, FAN_DEPTH + 0.1, FAN_DIAMETER / 2 + MATERIAL_THICKNESS + HEIGHT_FROM_FLOOR])
      rotate([90, 0, 0])
        cylinder(h = FAN_DEPTH + 0.2, d = FAN_DIAMETER);

    for (i = [0:1]) {
      translate([SCREW_OFFSET + FAN_SCREW_DISTANCE * i, FRONT_OVERHANG / 2 - 0.1 - MATERIAL_THICKNESS / 2,
            MATERIAL_THICKNESS + HEIGHT_FROM_FLOOR + SCREW_OFFSET])
        rotate([90, 0, 0]) screw(SCREW_DIAMETER, FAN_DEPTH + 0.2, true);

      // core holes M3
      translate([0, FRONT_OVERHANG + MATERIAL_THICKNESS + M3_HOLE, -0.1]) {
        translate([SCREW_OFFSET + FAN_SCREW_DISTANCE * i, 0, 0])
          cylinder(h = MATERIAL_THICKNESS + 0.2, d = M3_HOLE);

        if (FAN_DIAMETER == 80 || FAN_DIAMETER == 120) {
          translate([FAN_DIAMETER / 3 * (i + 1), UNC14_EDGE_OFFSET, 0])
            cylinder(d = UNC14_HOLE, h = MATERIAL_THICKNESS + 0.2);
        }
        if (FAN_DIAMETER == 140) {
          translate([FAN_DIAMETER / 2.8 + FAN_DIAMETER / 3.5 * i, UNC14_EDGE_OFFSET, 0])
            cylinder(d = UNC14_HOLE, h = MATERIAL_THICKNESS + 0.2);
        }
      }

      border_offset = 5;
      translate([border_offset + i * (FAN_DIAMETER - border_offset * 2), 12, MATERIAL_THICKNESS + .1]) screw(3.5, 12,
      true);
    }

    HEX_OD = FAN_DEPTH - (FAN_DEPTH / 5) - MATERIAL_THICKNESS - 3;
    usable_depth = STAND_DEPTH - FRONT_OVERHANG - MATERIAL_THICKNESS - (UNC14_HOLE - UNC14_EDGE_OFFSET);
    usable_width = FAN_DIAMETER - 4;
    translate([(FAN_DIAMETER - hexagon_get_used_width(usable_width, HEX_OD)) / 2,
          FRONT_OVERHANG + MATERIAL_THICKNESS + (HEX_OD - hexagon_get_used_width(usable_depth, HEX_OD)) / 2, 0
      ])
      rotate([180, 0, 0])
        translate([0, -FRONT_OVERHANG - MATERIAL_THICKNESS - 2 - usable_depth, -MATERIAL_THICKNESS])
          hexagon_pattern(usable_width, usable_depth, MATERIAL_THICKNESS, HEX_OD);
  }
}

// tested for diameters 80, 120, 140
// DIAMETER -> DISTANCE: 140 -> 125 | 120 -> 105 | 80 -> 71.5

translate([0, 50, 0]) fan_stand(80, 71.5);
translate([0, 100, 0]) fan_stand(120, 105);
translate([0, 150, 0]) fan_stand(140, 125);
