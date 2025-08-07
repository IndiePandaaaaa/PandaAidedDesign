// created by Lukas|@IndiePandaaaaa
// encoding: utf-8

use <Functions/ListTools.scad>
use <Parts/Screw.scad>
use <Parts/SplitToPrint.scad>

$fn = 75;

// mainboards
b450_pro_vdh_plus = [5, 9];

SCREW_OD = [7, 2.7];
STANDOFF_HEIGHT = 8;
STRAP_HEIGHT = 3;

mATX_SIZE = [243.8, 243.8];

module mainboard_support_grid(mainboard, screw_od, screw_od_core, standoff_height, strap_height = 3) {
  mATX_SCREWS = [
    [33.1, 6.4],
    [10.2, 157.4],
    [10.2, 203.2],
    [165.1, 6.4],
    [165.1, 157.4],
    [165.1, 203.2],
    [165.1, 223.5],
    [237.5, 6.4],
    [237.5, 157.4],
    [237.5, 203.2],
  ];

  module screw_grid(diameter, height) {
    mirror(v=[0, 1, 0]) {
      for (i = [0:len(mATX_SCREWS) - 1]) {
        if (!element_in_list(i, mainboard)) {
          translate(v=[mATX_SCREWS[i][0], mATX_SCREWS[i][1], height / 2]) cylinder(h=height, r=diameter / 2, center=true);
        }
      }
    }
  }

  module strap_grid(width, height) {
    // horizontal straps
    translate(v=[mATX_SCREWS[0][0], -width / 2 - mATX_SCREWS[0][1], 0]) cube(size=[mATX_SCREWS[7][0] - mATX_SCREWS[0][0], width, height], center=false);
    translate(v=[mATX_SCREWS[1][0], -width / 2 - mATX_SCREWS[1][1], 0]) cube(size=[mATX_SCREWS[8][0] - mATX_SCREWS[1][0], width, height], center=false);

    // vertical straps
    translate(v=[mATX_SCREWS[0][0] + width / 2, -mATX_SCREWS[0][1], 0]) rotate(a=180, v=[0, 0, 1]) cube(size=[width, mATX_SCREWS[1][1] - mATX_SCREWS[0][1], height], center=false);
    translate(v=[mATX_SCREWS[5][0] + width / 2, -mATX_SCREWS[0][1], 0]) rotate(a=180, v=[0, 0, 1]) cube(size=[width, mATX_SCREWS[1][1] - mATX_SCREWS[0][1], height], center=false);
    translate(v=[mATX_SCREWS[1][0] + width / 2, -mATX_SCREWS[1][1], 0]) rotate(a=180, v=[0, 0, 1]) cube(size=[width, mATX_SCREWS[2][1] - mATX_SCREWS[1][1], height], center=false);
    translate(v=[mATX_SCREWS[4][0] + width / 2, -mATX_SCREWS[4][1], 0]) rotate(a=180, v=[0, 0, 1]) cube(size=[width, mATX_SCREWS[6][1] - mATX_SCREWS[4][1], height], center=false);
  }

  union() {
    split_points = [0, 1, 3, 4];
    difference() {
      union() {
        screw_grid(diameter=screw_od, height=standoff_height);
        strap_grid(screw_od, strap_height);

        // support for splitting section
        for (point = split_points) {
          // horizontal
          translate(v=[mATX_SCREWS[point][0] + 10 * (point < 3 ? 1 : -1) + (point == 1 ? 25 : 0), -mATX_SCREWS[point][1], 0]) {
            rotate(a=(point < 3 ? 180 : 0), v=[0, 0, 1])
              split_with_screw_support(screw_standard=3, screw_count=1, material_thickness=STRAP_HEIGHT, material_width=SCREW_OD[0]);
          }
          // vertical
          translate(v=[mATX_SCREWS[ (point == 1 ? 0 : point) ][0], -mATX_SCREWS[point][1] - 10 * (point % 3 == 0 ? 1 : -1), 0]) {
            rotate(a=90 * (point == 1 || point == 4 ? -1 : 1), v=[0, 0, 1])
              split_with_screw_support(screw_standard=3, screw_count=1, material_thickness=STRAP_HEIGHT, material_width=SCREW_OD[0]);
          }
        }
      }

      // splitting section
      for (point = split_points) {
        // horizontal
        translate(v=[mATX_SCREWS[point][0] + 10 * (point < 3 ? 1 : -1) + (point == 1 ? 25 : 0), -mATX_SCREWS[point][1], 0]) {
          rotate(a=(point < 3 ? 180 : 0), v=[0, 0, 1])
            split_with_screw(screw_standard=3, screw_count=1, material_thickness=STRAP_HEIGHT, material_width=SCREW_OD[0]);
        }
        // vertical
        translate(v=[mATX_SCREWS[ (point == 1 ? 0 : point) ][0], -mATX_SCREWS[point][1] - 10 * (point % 3 == 0 ? 1 : -1), 0]) {
          rotate(a=90 * (point == 1 || point == 4 ? -1 : 1), v=[0, 0, 1])
            split_with_screw(screw_standard=3, screw_count=1, material_thickness=STRAP_HEIGHT, material_width=SCREW_OD[0]);
        }
      }
      // plate mounting holes
      translate(v=[mATX_SCREWS[0][0], -mATX_SCREWS[0][1] - mATX_SCREWS[1][1] / 2, strap_height + 2]) {
        screw_metric_countersunk(standard=3, length=12);
        translate(v=[-mATX_SCREWS[0][0] + mATX_SCREWS[3][0], 0, 0]) screw_metric_countersunk(standard=3, length=12);
      }
      translate(v=[(mATX_SCREWS[0][0] + mATX_SCREWS[3][0]) / 2, -mATX_SCREWS[0][1], strap_height + 2]) {
        screw_metric_countersunk(standard=3, length=12);
        translate(v=[0, mATX_SCREWS[0][1] - mATX_SCREWS[1][1], 0]) screw_metric_countersunk(standard=3, length=12);
      }

      // screw holes
      translate(v=[0, 0, -.1]) screw_grid(diameter=screw_od_core, height=standoff_height + .2);
    }
  }
}

mainboard_support_grid(mainboard=b450_pro_vdh_plus, screw_od=SCREW_OD[0], screw_od_core=SCREW_OD[1], standoff_height=STANDOFF_HEIGHT, strap_height=STRAP_HEIGHT);
