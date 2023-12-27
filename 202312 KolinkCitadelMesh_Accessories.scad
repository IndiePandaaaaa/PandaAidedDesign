// created by IndiePandaaaaa
// utf-8

use <Variables/Threading.scad>

TOLERANCE = .1;
THICKNESS = 3;
CHAMFER = 2;
$fn = 70;

CASEFOOT_DIAMETER = 40; // original: 40
CASEFOOT_HEIGHT = 15; // original: 15

COVER_HEIGHT = 5;
COVER_OVERLAP = 3;

module casefoot(height, diameter) {
  casefoot_hollow_diameter = 34.6;
  casefoot_hollow_height = 10.8;
  casefoot_inner_diameter = 37.5;
  casefoot_outer_diameter_height = 12.2;
  casefoot_locating_diameter = 4.8;
  casefoot_locating_height = 11.9;
  casefoot_holder_diameter = 8.4;
  casefoot_holder_height = 9.9;
  casefoot_bottom_plate_height = height - casefoot_hollow_height;
  
  difference() {
    union() {
      for (i = [1:3]) {
        rotate([0, 0, 120 * (i - 1)]) {
          translate([9.7, 0, 0])
            cylinder(d = casefoot_locating_diameter, h = casefoot_bottom_plate_height + casefoot_locating_height);
          
          rotate([0, 0, 30]) translate([-1, 0, 0])
            cube([2, casefoot_inner_diameter / 2 - .5, casefoot_bottom_plate_height + casefoot_holder_height]);
        }
      }
      
      cylinder(d = casefoot_holder_diameter, h = casefoot_bottom_plate_height + casefoot_holder_height);

      difference() {
        union() {
          cylinder(d = casefoot_inner_diameter, h = height);
          cylinder(d = diameter, h = casefoot_outer_diameter_height);
        }
        translate([0, 0, height - casefoot_hollow_height])
          cylinder(d = casefoot_hollow_diameter, h = casefoot_hollow_height);
      }
    }
    
    cylinder(d = core_hole_M4(), h = height);
  }
}

module radiator_pump_cover(height, overlap, thickness = 2, tolerance = .1) {
  // todo: square cover for radiator cutout with round cutout for the pump

  module silhouette(overlap, height, tolerance = .1) {
    rad_width = 140;
    rad_depth_cover = 40;
    pump_agb_diameter = 60;
    pump_agb_depth = 70;

    linear_extrude(height) {
      polygon([
        [0, 0],
      ]);
    }

  }
}

//casefoot(CASEFOOT_HEIGHT, CASEFOOT_DIAMETER);
radiator_pump_cover(COVER_HEIGHT, COVER_OVERLAP, THICKNESS, TOLERANCE);
