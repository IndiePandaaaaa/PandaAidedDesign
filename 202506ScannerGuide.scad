// created by IndiePandaaaaa
// encoding: utf-8

THICKNESS = 2.5;
$fn = $preview ? 25 : 75;

// made as A4 guide for HP ScanJet Pro 3000 s4

union() {
  linear_extrude(height=THICKNESS, center=false, convexity=10, twist=0, slices=20, scale=1.0) {
    le = 10;
    polygon(
      points=[
        [0, 3],
        [3, 0],
        [5, 0],
        [5, THICKNESS * 2 + 12],
        [35 + 3, THICKNESS * 2 + 12],
        [35 + 3, THICKNESS * 2 + 12 + le],
        [le, THICKNESS * 2 + 12 + le],
        [0, THICKNESS * 2 + 12],
      ]
    );
  }
  translate(v=[3, 0, 0]) linear_extrude(height=35, center=false, convexity=10, twist=0, slices=20, scale=1.0) {
      polygon(
        points=[
          [0, 0],
          [35, 0],
          [35, THICKNESS + .5],
          [THICKNESS, THICKNESS],
          [THICKNESS, THICKNESS + 12],
          [35, THICKNESS + 12],
          [35, THICKNESS * 2 + 12],
          [0, THICKNESS * 2 + 12],
        ]
      );
    }
}
