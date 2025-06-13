// created by IndiePandaaaaa|Lukas

use <Libraries/rcolyer_threads-scad/threads.scad>

TOLERANCE = 0.1;
MATERIAL_THICKNESS = 4;
PRINTING_READY = 50;
$fn = 75;

CLAW_WIDTH = 42;
CLAW_DEPTH = 42;
LAMP_OD_MOUNT = 26;
LAMP_HEIGHT_OFFSET = 165;
TABLE_THICKNESS = 28 * 1.5;
SCREW_DIAMETER = 20;

module lamp_adapter(od, outer_length, tolerance = 0.2) {
  // measurements from Rollei LUMIS LED-Panel Bi-Color
  inner_length = 30;
  id = 16.7;
  screw_depth = 7;
  bolt_dist = 8;
  bolt_diameter = 4.9;
  difference() {
    rotate_extrude() {
      polygon(
        [
          [0, 0],
          [(od - tolerance) / 2, 0],
          [(od - tolerance) / 2, outer_length - tolerance],
          [(id - tolerance) / 2, outer_length - tolerance],
          [(id - tolerance) / 2, outer_length + inner_length - tolerance],
          [0, outer_length + inner_length - tolerance],
        ]
      );
    }
    translate([id / 2 - screw_depth, 0, outer_length + bolt_dist + bolt_diameter / 2]) rotate([0, 90, 0])
        cylinder(d=bolt_diameter + tolerance, h=id * 2);
  }
}

module table_claw(table_thickness, width, depth, material_thickness = 3.5) {
  translate([-depth / 2, -width / 2, 0]) rotate([-90, 0, 0])
      linear_extrude(width) {
        polygon(
          [
            [0, 0],
            [depth, 0],
            [depth, material_thickness],
            [material_thickness, material_thickness],
            [material_thickness, material_thickness + table_thickness],
            [depth, material_thickness + table_thickness],
            [depth, material_thickness * 2 + table_thickness],
            [0, material_thickness * 2 + table_thickness],
          ]
        );
      }
}

module screw_socket(claw_width, claw_depth, diameter, material_thickness = 3.5, printing_ready = 50) {
  translate([0, 0, printing_ready])
    difference() {
      translate([(claw_depth) / 2, claw_width / 2, 0])
        MetricNut(diameter);
      translate([0, 0, material_thickness])
        cube(diameter * 2);
    }
  difference() {
    cube([claw_depth, claw_width, material_thickness]);
    translate([-material_thickness / 1.5, 0, 0])
      cube([material_thickness, claw_width, material_thickness]);
    translate([(claw_depth) / 2, claw_width / 2, 0]) {
      MetricNut(diameter + 0.2);
      cylinder(d=diameter + 2, h=diameter);
    }
  }
}

union() {
  difference() {
    union() {
      lamp_adapter(LAMP_OD_MOUNT, LAMP_HEIGHT_OFFSET);
      table_claw(TABLE_THICKNESS, CLAW_WIDTH, CLAW_DEPTH);
    }
    translate([0, 0, -(TABLE_THICKNESS + MATERIAL_THICKNESS * 2)])
      cylinder(d=SCREW_DIAMETER + 1, h=MATERIAL_THICKNESS * 2);
  }
  translate(
    [
      -( (CLAW_DEPTH - MATERIAL_THICKNESS) / 2) + PRINTING_READY,
      -(CLAW_WIDTH / 2),
      -(
        MATERIAL_THICKNESS + TABLE_THICKNESS
      ),
    ]
  )
    screw_socket(CLAW_WIDTH, CLAW_DEPTH, SCREW_DIAMETER, MATERIAL_THICKNESS * 2, PRINTING_READY);
}
translate([0, PRINTING_READY, -(SCREW_DIAMETER + MATERIAL_THICKNESS * 2 + TABLE_THICKNESS)])
  MetricBolt(SCREW_DIAMETER, TABLE_THICKNESS);
