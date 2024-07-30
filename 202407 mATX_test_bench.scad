// created by IndiePandaaaaa
// encoding: utf-8

$fn = 75;

SCREW_OD = 3.5;
mATX_SIZE = [243.8, 243.8];
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

translate([-mATX_SIZE[0], 0, 0]) rotate([180, 0, 0])
for (i = [0:len(mATX_SCREWS) - 1]) {
  translate([mATX_SCREWS[i][0], mATX_SCREWS[i][1], 0]) cylinder(d = SCREW_OD, h = 12);
}
