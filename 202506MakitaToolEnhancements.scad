// created by IndiePandaaaaa|Lukas
// encoding: utf-8

use <Variables/Threading.scad>

PARTS_SEPARATED = true;
THICKNESS = 2.5;
TOLERANCE = .1;
$fa = $preview ? 10 : .01; // add to smaller circles: , $fn=$preview ? 20 : 50

VACUUM_OD = 34.2;

module DBO180_custom_dust_holes(diameter, sander_plate = false) {
  // primarily made for makita DBO180 with 125 mm diameter
  id = diameter / (125 / 101.5);
  pattern_diameter = id - 16;
  base_thickness = 10;
  plate_thickness = 3;
  holes = [
    // hole_count, hole_diameter, position_diameter, offset_angle, hole_tilt
    [8, 12 - .15, 65.2, 0, 0], // standard holes
    [8, 8, 65.2, 0, 0], // standard holes
    [8, 8, 75, 22.5, 45], // additional holes
  ];

  module dust_holes(hole_count, hole_diameter, position_diameter, offset_angle, height = 0, tilt = 0) {
    cylinder_height = height == 0 ? base_thickness * 3 : height;
    union() {
      for (i = [0:hole_count]) {
        rotate(a=360 / hole_count * i + offset_angle, v=[0, 0, 1]) {
          translate(v=[position_diameter / 2, 0, tilt == 0 ? 0 : -hole_diameter / 2]) {
            rotate(a=tilt * -1, v=[0, 1, 0]) {
              cylinder(h=cylinder_height + .2, r=hole_diameter / 2, center=false, $fn=$preview ? 20 : 50);
            }
          }
        }
      }
    }
  }

  module pattern_plate(with_support = true) {
    translate(v=[0, 0, -base_thickness]) {

      // TODO: add top printing support
      union() {
        difference() {
          union() {
            if (sander_plate) cylinder(h=base_thickness, r1=diameter / 2, r2=id / 2, center=false);

            translate(v=[0, 0, base_thickness]) {
              // pattern plate
              cylinder(h=plate_thickness, r=pattern_diameter / 2, center=false);

              // basic holes from the sander, used for locating
              translate(v=[0, 0, -2.5]) dust_holes(hole_count=holes[0][0], hole_diameter=holes[0][1] - TOLERANCE, position_diameter=holes[0][2], offset_angle=holes[0][3], height=2.6);

              // additional dust holes
              difference() {
                translate(v=[0, 0, 2]) dust_holes(hole_count=holes[2][0], hole_diameter=holes[2][1] + 4, position_diameter=holes[2][2], offset_angle=holes[2][3], height=16, tilt=holes[2][4]);
                translate(v=[0, 0, -base_thickness]) cylinder(h=base_thickness, r=pattern_diameter, center=false);
              }
            }
          }
          translate(v=[0, 0, -.1 + base_thickness]) {
            cylinder(h=plate_thickness + .2, r=49 / 2, center=false);

            // dust extraction holes
            for (i = [1:len(holes)]) {
              dust_holes(hole_count=holes[i][0], hole_diameter=holes[i][1], position_diameter=holes[i][2], offset_angle=holes[i][3], height=0, tilt=holes[i][4]);
              if (i == 1) { translate(v=[0, 0, -plate_thickness]) dust_holes(hole_count=holes[i][0], hole_diameter=holes[i][1], position_diameter=holes[i][2], offset_angle=holes[i][3], height=0, tilt=holes[i][4]); }
            }
          }
        }
      }
    }
  }

  pattern_plate();

  translate(v=[0, 0, 30]) {
    linear_extrude(2) {
      //      projection(cut=false) { intersection() { pattern_plate(); cylinder(h=0.01, r=diameter * 2, center=false); } }
    }
  }
}

DBO180_custom_dust_holes(diameter=125);
