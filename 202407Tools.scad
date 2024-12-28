// created by IndiePandaaaaa|Lukas
// encoding: utf-8

PARTS_SEPARATED = true;
THICKNESS = 2.5;
TOLERANCE = .1;
$fn = 75;

module perpendicular_angle(width, depth, ruler_depth = 13, ruler_mode = 2.5) {
  // ruler_mode: 10 => cm; 5 => cm, 5 mm; 2.5 => cm, 2.5 mm; 1 => cm, mm; 0 => no ruler
  module ruler(width, mode, mirrored = false) {
    module marker(mode, label, mirrored = false) {
      width = 0.5;
      depth = 0.2 + TOLERANCE;
      length = [2.5, 1.5, 1];
      text_size = 5;

      translate([-width / 2, -length[mode], -depth + TOLERANCE]) {
        cube([width, length[mode], depth]);

        if (label != 0) {// 0: no label
          translate([0, -text_size - 1.75, 0]) linear_extrude(depth) {
            mirror(([mirrored ? 1 : 0, 0, 0]))
              text(str(label), size = text_size, font = "RecMonoCasualNerdFont", halign = "center");
          }
        }
      }
    }

    if (mode != 0) {
      for (i = [0:width - 1]) {
        translate([i, 0, 0]) {
          if (i % 10 == 0) {
            marker(0, i / 10, mirrored = mirrored);
          } else if (mode <= 5 && i % mode == 0) {
            marker(1, 0); // 0 means no label
          } else if (mode <= 2.5 && (i % 10 == 2 || i % 10 == 7)) {
            translate([.5, 0, 0]) marker(2, 0);
          }
        }
      }
    }
  }

  translate([-THICKNESS, 0, 0]) union() {
    translate([0, 0, -(10) / 2]) cube([THICKNESS, depth, 10 + THICKNESS]);

    translate([THICKNESS, 0, 0]) difference() {
      linear_extrude(THICKNESS) {
        polygon([
            [0, 0],
            [5, 0],
            [5, depth - ruler_depth],
            [width + TOLERANCE, depth - ruler_depth],
            [width + TOLERANCE, depth],
            [0, depth],
          ]);
      }
      for (i = [0:1])
      translate([0, depth, THICKNESS * i])
        ruler(width, ruler_mode, mirrored = i == 0 ? true : false);
    }
  }
}

perpendicular_angle(75, 50, ruler_depth=10, ruler_mode=0);
