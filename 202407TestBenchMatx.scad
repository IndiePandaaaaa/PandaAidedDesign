// created by IndiePandaaaaa
// encoding: utf-8

$fn = 75;

// mainboards
b450_pro_vdh_plus = [5, 9];

SCREW_OD = [7, 2.7];
STANDOFF_HEIGHT = 7;
STRAP_HEIGHT = 4.2;

mATX_SIZE = [243.8, 243.8];

function element_in_list(element, list) = len([for (e = [0:len(list)]) if (list[e] == element) 1]) > 0;

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

mainboard_support_grid(mainboard=b450_pro_vdh_plus, screw_od=SCREW_OD[0], screw_od_core=SCREW_OD[1], standoff_height=STANDOFF_HEIGHT, strap_height=STRAP_HEIGHT);
