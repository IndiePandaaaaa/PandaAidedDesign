// created by Lukas|@IndiePandaaaaa
// encoding: utf-8

use <Functions/ListTools.scad>
use <Parts/Screw.scad>
use <Parts/SplitToPrint.scad>

$fn = 75;

// mainboards (screws which are populated)
b450_pro_vdh_plus = [0, 1, 2, 4, 5, 7, 9, 10];
p8h61m_le = [0, 1, 2, 4, 5, 7];

miniITX = [0, 1, 4, 5];
microATX = [0, 1, 2, 4, 5, 6, 7, 9, 10];
ATX = [0, 1, 2, 3, 4, 5, 8, 9, 10, 11];

SCREW_OD = [7, 2.7];
STANDOFF_HEIGHT = 8;
STRAP_HEIGHT = 3;

module mainboard_support_grid(mainboard, screw_od, screw_od_core, standoff_height, strap_height = 3) {
  MAINBOARD_SCREW_POSITIONS = [
    [22.86, 6.35], // 0: ATX, µATX, mITX
    [10.16, 163.83], // 1: ATX, µATX, mITX
    [10.16, 209.55], // 2: ATX, µATX
    [10.16, 288.29], // 3: ATX
    [177.8, 6.35], // 4: ATX, µATX, mITX
    [177.8, 163.83], // 5: ATX, µATX, mITX
    [177.8, 209.55], // 6: µATX
    [177.8, 229.87], // 7: µATX
    [177.8, 288.29], // 8: ATX
    [237.49, 6.35], // 9: ATX, µATX
    [237.49, 163.83], // 10: ATX, µATX
    [237.49, 288.29], // 11: ATX
  ];

  module screw_grid(diameter, height) {
    mirror(v=[0, 1, 0]) {
      for (i = [0:len(MAINBOARD_SCREW_POSITIONS) - 1]) {
        if (element_in_list(i, mainboard)) {
          translate(v=[MAINBOARD_SCREW_POSITIONS[i][0], MAINBOARD_SCREW_POSITIONS[i][1], height / 2]) cylinder(h=height, r=diameter / 2, center=true);
        }
      }
    }
  }

  module strap_grid(width, height) {
    // mITX basic straps
    //// horizontal straps
    translate(v=[MAINBOARD_SCREW_POSITIONS[0][0], -MAINBOARD_SCREW_POSITIONS[0][1] - width / 2, 0])
      cube(size=[MAINBOARD_SCREW_POSITIONS[4][0] - MAINBOARD_SCREW_POSITIONS[0][0], width, height], center=false);
    translate(v=[MAINBOARD_SCREW_POSITIONS[1][0], -MAINBOARD_SCREW_POSITIONS[1][1] - width / 2, 0])
      cube(size=[MAINBOARD_SCREW_POSITIONS[5][0] - MAINBOARD_SCREW_POSITIONS[1][0], width, height], center=false);

    //// vertical straps
    translate(v=[MAINBOARD_SCREW_POSITIONS[0][0] - width / 2, -MAINBOARD_SCREW_POSITIONS[1][1], 0])
      cube(size=[width, MAINBOARD_SCREW_POSITIONS[1][1] - MAINBOARD_SCREW_POSITIONS[0][1], height], center=false);
    translate(v=[MAINBOARD_SCREW_POSITIONS[5][0] - width / 2, -MAINBOARD_SCREW_POSITIONS[5][1], 0])
      cube(size=[width, MAINBOARD_SCREW_POSITIONS[5][1] - MAINBOARD_SCREW_POSITIONS[4][1], height], center=false);

    // -------------------------------------------------------------------------------------------------------------------------------------------------

    //// optional straps: horizontal
    if (element_in_list(2, mainboard) && element_in_list(6, mainboard)) {
      translate(v=[MAINBOARD_SCREW_POSITIONS[2][0], -MAINBOARD_SCREW_POSITIONS[2][1] - width / 2, 0])
        cube(size=[MAINBOARD_SCREW_POSITIONS[6][0] - MAINBOARD_SCREW_POSITIONS[2][0], width, height], center=false);
    }
    if (element_in_list(3, mainboard) && element_in_list(8, mainboard)) {
      translate(v=[MAINBOARD_SCREW_POSITIONS[3][0], -MAINBOARD_SCREW_POSITIONS[3][1] - width / 3, 0])
        cube(size=[MAINBOARD_SCREW_POSITIONS[8][0] - MAINBOARD_SCREW_POSITIONS[3][0], width, height], center=false);
    }
    if (element_in_list(3, mainboard) && element_in_list(11, mainboard)) {
      translate(v=[MAINBOARD_SCREW_POSITIONS[3][0], -MAINBOARD_SCREW_POSITIONS[3][1] - width / 3, 0])
        cube(size=[MAINBOARD_SCREW_POSITIONS[11][0] - MAINBOARD_SCREW_POSITIONS[3][0], width, height], center=false);
    }
    if (element_in_list(4, mainboard) && element_in_list(9, mainboard)) {
      translate(v=[MAINBOARD_SCREW_POSITIONS[4][0], -MAINBOARD_SCREW_POSITIONS[4][1] - width / 2, 0])
        cube(size=[MAINBOARD_SCREW_POSITIONS[9][0] - MAINBOARD_SCREW_POSITIONS[4][0], width, height], center=false);
    }
    if (element_in_list(5, mainboard) && element_in_list(10, mainboard)) {
      translate(v=[MAINBOARD_SCREW_POSITIONS[5][0], -MAINBOARD_SCREW_POSITIONS[5][1] - width / 2, 0])
        cube(size=[MAINBOARD_SCREW_POSITIONS[10][0] - MAINBOARD_SCREW_POSITIONS[5][0], width, height], center=false);
    }

    //// optional straps: vertical
    if (element_in_list(1, mainboard) && element_in_list(2, mainboard)) {
      translate(v=[MAINBOARD_SCREW_POSITIONS[2][0] - width / 2, -MAINBOARD_SCREW_POSITIONS[2][1], 0])
        cube(size=[width, MAINBOARD_SCREW_POSITIONS[2][1] - MAINBOARD_SCREW_POSITIONS[1][1], height], center=false);
    }
    if (element_in_list(5, mainboard) && element_in_list(7, mainboard)) {
      translate(v=[MAINBOARD_SCREW_POSITIONS[7][0] - width / 2, -MAINBOARD_SCREW_POSITIONS[7][1], 0])
        cube(size=[width, MAINBOARD_SCREW_POSITIONS[7][1] - MAINBOARD_SCREW_POSITIONS[5][1], height], center=false);
    }
    if (element_in_list(1, mainboard) && element_in_list(3, mainboard)) {
      translate(v=[MAINBOARD_SCREW_POSITIONS[3][0] - width / 2, -MAINBOARD_SCREW_POSITIONS[3][1], 0])
        cube(size=[width, MAINBOARD_SCREW_POSITIONS[3][1] - MAINBOARD_SCREW_POSITIONS[1][1], height], center=false);
    }
    if (element_in_list(5, mainboard) && element_in_list(8, mainboard)) {
      translate(v=[MAINBOARD_SCREW_POSITIONS[8][0] - width / 2, -MAINBOARD_SCREW_POSITIONS[8][1], 0])
        cube(size=[width, MAINBOARD_SCREW_POSITIONS[8][1] - MAINBOARD_SCREW_POSITIONS[5][1], height], center=false);
    }
    if (element_in_list(9, mainboard) && element_in_list(10, mainboard)) {
      translate(v=[MAINBOARD_SCREW_POSITIONS[10][0] - width / 2, -MAINBOARD_SCREW_POSITIONS[10][1], 0])
        cube(size=[width, MAINBOARD_SCREW_POSITIONS[10][1] - MAINBOARD_SCREW_POSITIONS[9][1], height], center=false);
    }
    if (element_in_list(10, mainboard) && element_in_list(11, mainboard)) {
      translate(v=[MAINBOARD_SCREW_POSITIONS[11][0] - width / 2, -MAINBOARD_SCREW_POSITIONS[11][1], 0])
        cube(size=[width, MAINBOARD_SCREW_POSITIONS[11][1] - MAINBOARD_SCREW_POSITIONS[10][1], height], center=false);
    }
  }

  union() {
    //    split_points = [0, 1, 4, 5];
    difference() {
      union() {
        screw_grid(diameter=screw_od, height=standoff_height);
        strap_grid(screw_od, strap_height);

        //        // support for splitting section
        //        for (point = split_points) {
        //          // horizontal
        //          translate(v=[MAINBOARD_SCREW_POSITIONS[point][0] + 10 * (point < 4 ? 1 : -1) + (point == 1 ? 25 : 0), -MAINBOARD_SCREW_POSITIONS[point][1], 0]) {
        //            rotate(a=(point < 4 ? 180 : 0), v=[0, 0, 1])
        //              split_with_screw_support(screw_standard=3, screw_count=1, material_thickness=STRAP_HEIGHT, material_width=SCREW_OD[0]);
        //          }
        //          // vertical
        //          translate(v=[MAINBOARD_SCREW_POSITIONS[ (point == 1 ? 0 : point) ][0], -MAINBOARD_SCREW_POSITIONS[point][1] - 10 * (point % 3 == 0 ? 1 : -1), 0]) {
        //            rotate(a=90 * (point == 1 || point == 4 ? -1 : 1), v=[0, 0, 1])
        //              split_with_screw_support(screw_standard=3, screw_count=1, material_thickness=STRAP_HEIGHT, material_width=SCREW_OD[0]);
        //          }
        //        }
      }

      // splitting section
      //      for (point = split_points) {
      //        // horizontal
      //        translate(v=[MAINBOARD_SCREW_POSITIONS[point][0] + 10 * (point < 4 ? 1 : -1) + (point == 1 ? 25 : 0), -MAINBOARD_SCREW_POSITIONS[point][1], 0]) {
      //          rotate(a=(point < 4 ? 180 : 0), v=[0, 0, 1])
      //            split_with_screw(screw_standard=3, screw_count=1, material_thickness=STRAP_HEIGHT, material_width=SCREW_OD[0]);
      //        }
      //        // vertical
      //        translate(v=[MAINBOARD_SCREW_POSITIONS[ (point == 1 ? 0 : point) ][0], -MAINBOARD_SCREW_POSITIONS[point][1] - 10 * (point % 3 == 0 ? 1 : -1), 0]) {
      //          rotate(a=90 * (point == 1 || point == 4 ? -1 : 1), v=[0, 0, 1])
      //            split_with_screw(screw_standard=3, screw_count=1, material_thickness=STRAP_HEIGHT, material_width=SCREW_OD[0]);
      //        }
      //      }
      // plate mounting holes
      translate(v=[MAINBOARD_SCREW_POSITIONS[0][0], -MAINBOARD_SCREW_POSITIONS[0][1] - MAINBOARD_SCREW_POSITIONS[1][1] / 2, strap_height + 2]) {
        screw_metric_countersunk(standard=3, length=12);
        translate(v=[-MAINBOARD_SCREW_POSITIONS[0][0] + MAINBOARD_SCREW_POSITIONS[4][0], 0, 0]) screw_metric_countersunk(standard=3, length=12);
      }
      translate(v=[(MAINBOARD_SCREW_POSITIONS[0][0] + MAINBOARD_SCREW_POSITIONS[4][0]) / 2, -MAINBOARD_SCREW_POSITIONS[0][1], strap_height + 2]) {
        screw_metric_countersunk(standard=3, length=12);
        translate(v=[0, MAINBOARD_SCREW_POSITIONS[0][1] - MAINBOARD_SCREW_POSITIONS[1][1], 0]) screw_metric_countersunk(standard=3, length=12);
      }

      // screw holes
      translate(v=[0, 0, -.1]) screw_grid(diameter=screw_od_core, height=standoff_height + .2);
    }
  }
}

//mainboard_support_grid(mainboard=b450_pro_vdh_plus, screw_od=SCREW_OD[0], screw_od_core=SCREW_OD[1], standoff_height=STANDOFF_HEIGHT, strap_height=STRAP_HEIGHT);
mainboard_support_grid(mainboard=miniITX, screw_od=SCREW_OD[0], screw_od_core=SCREW_OD[1], standoff_height=STANDOFF_HEIGHT, strap_height=STRAP_HEIGHT);
