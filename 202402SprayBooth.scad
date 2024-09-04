// created by IndiePandaaaaa

use <Structures/Hexagon.scad>
use <Variables/Threading.scad>
use <Parts/Screw.scad>

TOLERANCE = .15;
THICKNESS = 3;
$fn = 75;

FAN_DIAMETER = 120;
FAN_SCREW_DISTANCE = 105;

HEX_SIZE = 12;

module fan_grill(diameter, screw_distance, hex_size, thickness, tolerance = .1) {
  screw_diameter = 4.2; // fan screw hole: 4.3 mm
  screw_offset = (diameter - screw_distance) / 2;
  hexagon = diameter - 3;
  cube_chamfer = 2 * ((diameter / 2) / sin(45) - 5);

  union() {
    difference() {
      intersection() {
        cube([diameter, diameter, thickness]);
        translate([diameter / 2, diameter / 2, -.1]) rotate([0, 0, 45]) translate([-cube_chamfer / 2, -cube_chamfer / 2, 0]) 
          cube([cube_chamfer, cube_chamfer, thickness + .2]);
      }

      translate([diameter / 2, diameter / 2, -.1]) intersection() {
        cylinder(d = hexagon, h = thickness + .2, $fn = 6);
        cylinder(d = diameter - 7, h = thickness + .2);
      }

      translate([screw_offset, screw_offset, thickness + .1]) {
        screw(screw_diameter, 12, true);
        translate([screw_distance, 0, 0]) screw(screw_diameter, 12, true);
        translate([0, screw_distance, 0]) screw(screw_diameter, 12, true);
        translate([screw_distance, screw_distance, 0]) screw(screw_diameter, 12, true);
      }
    }

    translate([-11.5, 2, 0]) difference() {
      translate([diameter / 2 + 11.5, diameter / 2 - 2, 0]) cylinder(d = hexagon, h = thickness, $fn = 6);
      translate([0, 0, -.1]) hexagon_pattern(diameter * 2, diameter * 2, thickness + .2, hex_size);
    }
  }
}

module fan_mount(diameter, screw_distance, thickness, tolerance = .1, screw_standard = "M4") {
  module wood_mounting(width, distance, wood_screw_diameter) {
    for (i = [0:1]) {
      translate([- distance / 2 + distance * i, - (width - distance * 2) / 2, 0]) {
        difference() {
          cube([wood_screw_diameter * 4, width, thickness]);
                
          for (k = [0:1]) {
            translate([wood_screw_diameter * 2, wood_screw_diameter * 2 + (width - wood_screw_diameter * 4) * k, thickness + .1])
              screw(wood_screw_diameter, 12, true);
          }
        }
      }
    }
  }

  wood_screws = 3.5;
  screw_offset = (diameter - screw_distance) / 2;
  cube_chamfer = 2 * ((diameter / 2) / sin(45) - 4);
  frame_thickness = thickness * 2;

  translate([diameter / 2, diameter / 2, 0]) union() {
    difference() {
      translate([- diameter / 2, - diameter / 2, 0]) {
        cube([diameter, diameter, frame_thickness]);

        translate([(diameter - wood_screws * 4) / 2, 0, 0]) {
          wood_mounting(diameter + wood_screws * 4 * 2, diameter / 2, thickness);
        }
      }

      translate([0, 0, -.1]) rotate([0, 0, 90 / 4]) cylinder(d = diameter - 7, h = frame_thickness + .2);
    
      // outer holes for fan mounting screws
      for (i = [0:3]) {
        rotate([0, 0, 90 * i]) translate([diameter / 2 - screw_offset, diameter / 2 - screw_offset, -.1])
          cylinder(d = core_hole(screw_standard), h = frame_thickness + .2);
      }
    }

    parts = 4;
    for (i = [0:parts])
      rotate([0, 0, 360 / parts * i])
        translate([- (diameter - 5) / 2 / 3, - diameter / 2, 0])
          cube([5, diameter, thickness]);
  }
}

translate([0, 0, 25]) fan_grill(FAN_DIAMETER, FAN_SCREW_DISTANCE, HEX_SIZE, THICKNESS / 6 * 5, TOLERANCE);

fan_mount(FAN_DIAMETER, FAN_SCREW_DISTANCE, THICKNESS, TOLERANCE);

