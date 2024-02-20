// created by IndiePandaaaaa

use <Structures/Hexagon.scad>
use <Variables/Threading.scad>
use <Parts/Screw.scad>

TOLERANCE = .15;
THICKNESS = 2.5;
$fn = 75;

FAN_DIAMETER = 120;
FAN_SCREW_DISTANCE = 105;

HEX_SIZE = 12;

module fan_grill(diameter, screw_distance, hex_size, thickness, tolerance = .1) {
  screw_diameter = 4.3 + .5;
  screw_offset = (diameter - screw_distance) / 2;

  union() {
    hexagon = diameter - 3;
    cube_chamfer = 2 * ((diameter / 2) / sin(45) - 5);

    difference() {
      intersection() {
        cube([diameter, diameter, THICKNESS]);
        translate([diameter / 2, diameter / 2, -.1]) rotate([0, 0, 45]) translate([-cube_chamfer / 2, -cube_chamfer / 2, 0]) 
          cube([cube_chamfer, cube_chamfer, thickness + .2]);
      }

      translate([diameter / 2, diameter / 2, -.1]) cylinder(d = hexagon, h = thickness + .2, $fn = 6);

      translate([screw_offset, screw_offset, -.1]) {
        cylinder(d = screw_diameter, h = thickness + .2 + 20);
        translate([screw_distance, 0, 0]) cylinder(d = screw_diameter, h = thickness + .2 + 20);
        translate([0, screw_distance, 0]) cylinder(d = screw_diameter, h = thickness + .2 + 20);
        translate([screw_distance, screw_distance, 0])
          cylinder(d = screw_diameter, h = thickness + .2 + 20);
      }
    }

    translate([-11.5, 2, 0]) difference() {
      translate([diameter / 2 + 11.5, diameter / 2 - 2, 0]) cylinder(d = hexagon, h = thickness, $fn = 6);
      translate([0, 0, -.1]) hexagon_pattern(diameter * 2, diameter * 2, thickness + .2, hex_size);
    }
  }
}

module fan_mount(diameter, screw_distance, thickness, tolerance = .1, screw_standard = "M3") {
  wood_screws = 3.5;
  screw_offset = (diameter - screw_distance) / 2;

  difference() {
    union() {
      cube([diameter, diameter, thickness]);
      translate([(diameter - wood_screws * 4) / 2, - wood_screws * 4, 0]) 
        cube([wood_screws * 4, diameter + wood_screws * 4 * 2, thickness]);
    }

    translate([diameter / 2, diameter / 2, -.1]) cylinder(d = diameter - 2, h = thickness + .2);
  
    translate([diameter / 2, - wood_screws * 2, thickness + .1]) screw(wood_screws, 12, true);
    translate([diameter / 2, wood_screws * 2 + diameter, thickness + .1]) screw(wood_screws, 12, true);

    translate([screw_offset, screw_offset, -.1]) 
      cylinder(d = core_hole(screw_standard), h = thickness + .2);
    translate([screw_offset + screw_distance, screw_offset, -.1]) 
      cylinder(d = core_hole(screw_standard), h = thickness + .2);
    translate([screw_offset, screw_offset + screw_distance, -.1])
      cylinder(d = core_hole(screw_standard), h = thickness + .2);
    translate([screw_offset + screw_distance, screw_offset + screw_distance, -.1])
      cylinder(d = core_hole(screw_standard), h = thickness + .2);
  }
}

translate([0, 0, -30]) fan_grill(FAN_DIAMETER, FAN_SCREW_DISTANCE, HEX_SIZE, THICKNESS, TOLERANCE);

fan_mount(FAN_DIAMETER, FAN_SCREW_DISTANCE, THICKNESS * 1.75, TOLERANCE);

