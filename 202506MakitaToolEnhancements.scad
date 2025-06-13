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
  plate_od = id - 16;
  plate_thickness = 3;
  plate_id = 48;
  base_thickness = 10;

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

      difference() {
        union() {
          if (sander_plate) cylinder(h=base_thickness, r1=diameter / 2, r2=id / 2, center=false);

          if (with_support) {
            translate(v=[0, 0, base_thickness + plate_thickness]) {
              rotate_extrude(angle=360, convexity=2) {
                translate(v=[plate_id / 2, 0]) {
                  polygon(
                    points=[
                      [0, 0],
                      [(plate_od - plate_id) / 2, 0],
                      [10.25, 7.5],
                      [7.25, 7.5],
                    ]
                  );
                }
              }
            }
          }

          translate(v=[0, 0, base_thickness]) {
            // pattern plate
            cylinder(h=plate_thickness, r=plate_od / 2, center=false);

            // basic holes from the sander, used for locating
            translate(v=[0, 0, -2.5]) dust_holes(hole_count=holes[0][0], hole_diameter=holes[0][1] - TOLERANCE, position_diameter=holes[0][2], offset_angle=holes[0][3], height=2.6);

            // additional dust holes
            difference() {
              translate(v=[0, 0, 2]) dust_holes(hole_count=holes[2][0], hole_diameter=holes[2][1] + 4, position_diameter=holes[2][2], offset_angle=holes[2][3], height=14.5, tilt=holes[2][4]);
              translate(v=[0, 0, -base_thickness]) cylinder(h=base_thickness, r=plate_od, center=false);
            }
          }
        }
        translate(v=[0, 0, -.1 + base_thickness]) {
          cylinder(h=plate_thickness + .2, r=plate_id / 2, center=false);

          // dust extraction holes
          for (i = [1:len(holes)]) {
            dust_holes(hole_count=holes[i][0], hole_diameter=holes[i][1], position_diameter=holes[i][2], offset_angle=holes[i][3], height=0, tilt=holes[i][4]);
            if (i == 1) { translate(v=[0, 0, -plate_thickness]) dust_holes(hole_count=holes[i][0], hole_diameter=holes[i][1], position_diameter=holes[i][2], offset_angle=holes[i][3], height=0, tilt=holes[i][4]); }
          }
        }

        if (with_support) {
          translate(v=[0, 0, base_thickness + plate_thickness + 7.5]) cylinder(h=1, r=plate_od + 1, center=false);
        }
      }
    }
  }

  pattern_plate();

  translate(v=[0, 0, 30]) {
    union() {
      linear_extrude(2) {
        projection(cut=false) { intersection() { pattern_plate(); cylinder(h=0.01, r=diameter * 2, center=false); } }
      }

      translate(v=[0, 0, -2.5]) difference() {
          dust_holes(hole_count=holes[0][0], hole_diameter=holes[0][1] - TOLERANCE, position_diameter=holes[0][2], offset_angle=holes[0][3], height=2.6);
          translate(v=[0, 0, -.1]) dust_holes(hole_count=holes[1][0], hole_diameter=holes[1][1], position_diameter=holes[1][2], offset_angle=holes[1][3], height=0, tilt=holes[1][4]);
        }
    }
  }
}

DBO180_custom_dust_holes(diameter=125);
