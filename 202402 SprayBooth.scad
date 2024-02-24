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
  screw_diameter = core_hole("M4"); // fan screw hole: 4.3 mm
  screw_offset = (diameter - screw_distance) / 2;
  hexagon = diameter - 3;
  cube_chamfer = 2 * ((diameter / 2) / sin(45) - 5);

  union() {
    difference() {
      intersection() {
        cube([diameter, diameter, THICKNESS]);
        translate([diameter / 2, diameter / 2, -.1]) rotate([0, 0, 45]) translate([-cube_chamfer / 2, -cube_chamfer / 2, 0]) 
          cube([cube_chamfer, cube_chamfer, thickness + .2]);
      }

      translate([diameter / 2, diameter / 2, -.1]) cylinder(d = hexagon, h = thickness + .2, $fn = 6);

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
  wood_screws = 3.5;
  screw_offset = (diameter - screw_distance) / 2;
  cube_chamfer = 2 * ((diameter / 2) / sin(45) - 4);
  frame_thickness = thickness * 2;

  translate([diameter / 2, diameter / 2, 0]) union() {
    difference() {
      translate([- diameter / 2, - diameter / 2, 0]) union() {
        cube([diameter, diameter, frame_thickness]);

        translate([(diameter - wood_screws * 4) / 2, - wood_screws * 4, 0]) {
          for (i = [0:1]) {
            translate([-diameter / 4 + diameter / 2 * i, 0, 0]) {
              difference() {
                cube([wood_screws * 4, diameter + wood_screws * 4 * 2, thickness]);
              
                for (k = [0:1]) {
                  translate([wood_screws * 2, wood_screws * 2 + (wood_screws * 4 + diameter) * k, thickness + .1])
                    screw(wood_screws, 12, true);
                }
              }
            }
          }
        }
      }

      translate([0, 0, -.1]) rotate([0, 0, 90 / 4]) cylinder(d = diameter - 2, h = frame_thickness + .2, $fn = 8);
    
      for (i = [0:3]) {
        rotate([0, 0, 90 * i]) translate([diameter / 2 - screw_offset, diameter / 2 - screw_offset, -.1])
          cylinder(d = core_hole(screw_standard), h = frame_thickness + .2);
      }
    }

    // todo: add inner reinforcement, to keep the filter out of the fan
    difference() {

    }
  }
}

//translate([0, 0, -30]) fan_grill(FAN_DIAMETER, FAN_SCREW_DISTANCE, HEX_SIZE, THICKNESS / 6 * 5, TOLERANCE);

fan_mount(FAN_DIAMETER, FAN_SCREW_DISTANCE, THICKNESS, TOLERANCE);

