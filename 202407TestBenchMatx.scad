// created by IndiePandaaaaa
// encoding: utf-8

use <Parts/Screw.scad>

$fn = 75;

// mainboards
b450_pro_vdh_plus = [5, 9];

SCREW_OD = [7, 2.7];
STANDOFF_HEIGHT = 7;
STRAP_HEIGHT = 3;

mATX_SIZE = [243.8, 243.8];

function element_in_list(element, list) = len([for (e = [0:len(list)]) if (list[e] == element) 1]) > 0;

module screw_split(cutaway_part, screws, material_thickness, material_width, screw_od_core, screw_od, cut_thickness = .1, screw_length = 5) {
  // screw standard is M3. DIN7991. countersunk head depth min. is 1.7 mm
  countersunk_height = 1.7;
  screw_distance_factor = 3;
  screw_length_additional = .5;
  material_height_bottom = screw_length - countersunk_height + screw_length_additional;

  union() {
    translate(v=[-cut_thickness, -cut_thickness, -cut_thickness]) {
      mirror(v=[0, 1, 0]) {
        rotate(a=90, v=[1, 0, 0]) {
          linear_extrude(height=material_width + .2, center=false) {
            polygon(
              points=[
                [0, 0],
                [cut_thickness, 0],
                [cut_thickness, material_height_bottom + cut_thickness * 1],
                [cut_thickness * 3 + screw_od * screw_distance_factor * screws, material_height_bottom + cut_thickness * 1],
                [cut_thickness * 3 + screw_od * screw_distance_factor * screws, screw_length + screw_length_additional + cut_thickness * 3],
                [cut_thickness * 2 + screw_od * screw_distance_factor * screws, screw_length + screw_length_additional + cut_thickness * 3],
                [cut_thickness * 2 + screw_od * screw_distance_factor * screws, material_height_bottom + cut_thickness * 2],
                [0, material_height_bottom + cut_thickness * 2],
              ]
            );
          }
        }
      }
    }

    for (i = [0:screws - 1]) {
      translate(v=[(screw_od * screw_distance_factor) / 2 + (screw_od * screw_distance_factor) * i, (cut_thickness * 2 + material_width) / 2, cone_height(diameter=3) + material_height_bottom]) {
        SCREW_METRIC_COUNTERSUNK(standard=3, length=7, unthreaded_length=.4, borehole_length=5);
      }
    }
  }
}

module mainboard_support_grid(mainboard, screw_od, screw_od_core, standoff_height = 7, strap_height = 3) {
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
  union() {
    mirror(v=[0, 1, 0]) {
      for (i = [0:len(mATX_SCREWS) - 1]) {
        if (!element_in_list(i, mainboard)) {
          translate(v=[mATX_SCREWS[i][0], mATX_SCREWS[i][1], standoff_height / 2]) {
            linear_extrude(height=standoff_height, center=true) {
              difference() {
                circle(r=screw_od / 2);
                circle(r=screw_od_core / 2);
              }
            }
          }
        }
      }
    }

    // horizontal straps
    translate(v=[mATX_SCREWS[0][0], -screw_od / 2 - mATX_SCREWS[0][1], 0]) cube(size=[mATX_SCREWS[7][0] - mATX_SCREWS[0][0], screw_od, strap_height], center=false);
    translate(v=[mATX_SCREWS[1][0], -screw_od / 2 - mATX_SCREWS[1][1], 0]) cube(size=[mATX_SCREWS[8][0] - mATX_SCREWS[1][0], screw_od, strap_height], center=false);

    // vertical straps
    translate(v=[mATX_SCREWS[0][0] + screw_od / 2, -mATX_SCREWS[0][1], 0]) rotate(a=180, v=[0, 0, 1]) cube(size=[screw_od, mATX_SCREWS[1][1] - mATX_SCREWS[0][1], strap_height], center=false);
    translate(v=[mATX_SCREWS[5][0] + screw_od / 2, -mATX_SCREWS[0][1], 0]) rotate(a=180, v=[0, 0, 1]) cube(size=[screw_od, mATX_SCREWS[1][1] - mATX_SCREWS[0][1], strap_height], center=false);
    translate(v=[mATX_SCREWS[1][0] + screw_od / 2, -mATX_SCREWS[1][1], 0]) rotate(a=180, v=[0, 0, 1]) cube(size=[screw_od, mATX_SCREWS[2][1] - mATX_SCREWS[1][1], strap_height], center=false);
    translate(v=[mATX_SCREWS[4][0] + screw_od / 2, -mATX_SCREWS[4][1], 0]) rotate(a=180, v=[0, 0, 1]) cube(size=[screw_od, mATX_SCREWS[6][1] - mATX_SCREWS[4][1], strap_height], center=false);

    // splitting section
    // TODO: add board support blocks to prevent pcb contact with screws
  }
}

union() {
  mainboard_support_grid(mainboard=b450_pro_vdh_plus, screw_od=SCREW_OD[0], screw_od_core=SCREW_OD[1], standoff_height=STANDOFF_HEIGHT, strap_height=STRAP_HEIGHT);
  translate(v=[0, -SCREW_OD[0] / 2, 0]) screw_split(cutaway_part=false, screws=1, material_thickness=STRAP_HEIGHT, material_width=SCREW_OD[0], screw_od_core=SCREW_OD[1], screw_od=SCREW_OD[0]);
}
