// created by IndiePandaaaaa
// encoding: utf-8

$fn = 75;

SCREW_OD = [7, 2.7];
STANDOFF_HEIGHT = 7;
BRACKET_HEIGHT = 4.2;

mATX_SIZE = [243.8, 243.8];
mATX_SCREWS = [
  [33.1, 6.4],
  [10.2, 157.4],
  [10.2, 203.2],
  [165.1, 6.4],
  [165.1, 157.4],
  //  [165.1, 203.2],
  [165.1, 223.5],
  [237.5, 6.4],
  [237.5, 157.4],
  // [237.5, 203.2],
];

union() {
  mirror(v=[0, 1, 0]) {
    for (i = [0:len(mATX_SCREWS) - 1]) {
      translate(v=[mATX_SCREWS[i][0], mATX_SCREWS[i][1], STANDOFF_HEIGHT / 2]) {
        linear_extrude(height=STANDOFF_HEIGHT, center=true) {
          difference() {
            circle(r=SCREW_OD[0] / 2);
            circle(r=SCREW_OD[1] / 2);
          }
        }
      }
    }
  }

  // horizontal straps
  translate(v=[mATX_SCREWS[0][0], -SCREW_OD[0] / 2 - mATX_SCREWS[0][1], 0]) cube(size=[mATX_SCREWS[6][0] - mATX_SCREWS[0][0], SCREW_OD[0], BRACKET_HEIGHT], center=false);
  translate(v=[mATX_SCREWS[1][0], -SCREW_OD[0] / 2 - mATX_SCREWS[1][1], 0]) cube(size=[mATX_SCREWS[7][0] - mATX_SCREWS[1][0], SCREW_OD[0], BRACKET_HEIGHT], center=false);

  // vertical straps
  translate(v=[mATX_SCREWS[0][0] + SCREW_OD[0] / 2, -mATX_SCREWS[0][1], 0]) rotate(a=180, v=[0, 0, 1]) cube(size=[SCREW_OD[0], mATX_SCREWS[1][1] - mATX_SCREWS[0][1], BRACKET_HEIGHT], center=false);
  translate(v=[mATX_SCREWS[4][0] + SCREW_OD[0] / 2, -mATX_SCREWS[0][1], 0]) rotate(a=180, v=[0, 0, 1]) cube(size=[SCREW_OD[0], mATX_SCREWS[1][1] - mATX_SCREWS[0][1], BRACKET_HEIGHT], center=false);
  translate(v=[mATX_SCREWS[1][0] + SCREW_OD[0] / 2, -mATX_SCREWS[1][1], 0]) rotate(a=180, v=[0, 0, 1]) cube(size=[SCREW_OD[0], mATX_SCREWS[2][1] - mATX_SCREWS[1][1], BRACKET_HEIGHT], center=false);
  translate(v=[mATX_SCREWS[4][0] + SCREW_OD[0] / 2, -mATX_SCREWS[4][1], 0]) rotate(a=180, v=[0, 0, 1]) cube(size=[SCREW_OD[0], mATX_SCREWS[5][1] - mATX_SCREWS[4][1], BRACKET_HEIGHT], center=false);
}
