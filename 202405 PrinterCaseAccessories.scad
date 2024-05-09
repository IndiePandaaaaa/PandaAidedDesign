// created by IndiePandaaaaa
// encoding: utf-8

use <Parts/Screw.scad>
use <Functions/Fillet.scad>
use <Logo/logo.scad>

module logo_plate(width, thickness = 3, tolerance = .1) {
  platsa_mounting_distance = 25;
  screw_od = 3.5;

  rotate([90, 0, 0]) difference() {
    union() {
      color("white") cube([width, width , thickness]);
      translate([(width * .2) / 2, 0, thickness]) color("black") generate_logo(width = width * .8, height = width, thickness = 1);
    }
    translate([screw_od * 2, screw_od * 2, thickness + .1]) screw(screw_od, 12, true);
    translate([screw_od * 2, screw_od * 2 + platsa_mounting_distance * floor(width / platsa_mounting_distance), 
      thickness + .1]) screw(screw_od, 12, true);
  }
}

logo_plate(width = 114);
