// created by IndiePandaaaaa
// encoding: utf-8

$fn = 75;

SCREW_OD = [7, 2.7];
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


translate([-mATX_SIZE[0] / 2, mATX_SIZE[1] / 2, 0]) rotate([180, 0, 0])
  for (i = [0:len(mATX_SCREWS) - 1]) {
    standoff_height = 7;
    translate([mATX_SCREWS[i][0], mATX_SCREWS[i][1], standoff_height / 2]) difference() {
      cylinder(d = SCREW_OD[0], h = standoff_height, center = true);
      cylinder(d = SCREW_OD[1], h = standoff_height + .2, center = true);
    }
  }
