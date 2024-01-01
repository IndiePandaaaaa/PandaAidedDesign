// created by IndiePandaaaaa

TOLERANCE = .1;
THICKNESS = 2.5;
CHAMFER = 1;
$fn = 75;

// model for reference: Logitech Logi ERGO M575

ANGLE = 30;
WIDTH = 90;
HEIGHT = sin(ANGLE) * WIDTH;
DEPTH = 120;

intersection() {
  translate([- WIDTH / 2 + (DEPTH - WIDTH) / 2, DEPTH / 2, 0]) rotate([90, 0, 0]) {
    linear_extrude(DEPTH) {
      polygon([
        [0, 0],
        [WIDTH, 0],
        [0, HEIGHT],
      ]);
    }
  }
  difference() {
    dia_little = 35;
    middle_ball_offset = 5;
    union() {
      difference() {
        cylinder(d = DEPTH, h = HEIGHT);
        translate([-DEPTH, - DEPTH / 2, -1]) cube(DEPTH);
      }

      translate([0, DEPTH / 2 - dia_little / 2, 0]) cylinder(d = dia_little, h = HEIGHT);
      translate([0, -DEPTH / 2 + dia_little / 2, 0]) cylinder(d = dia_little, h = HEIGHT);
      translate([- WIDTH + (DEPTH / 2) + dia_little / 2, middle_ball_offset, 0]) cylinder(d = dia_little, h = HEIGHT);
      translate([(- WIDTH + (DEPTH / 2) + dia_little / 2) * .5, middle_ball_offset * - 3.25, 0]) cylinder(d = dia_little, h = HEIGHT);
      translate([(- WIDTH + (DEPTH / 2) + dia_little / 2) * .5, middle_ball_offset * 3.75, 0]) cylinder(d = dia_little, h = HEIGHT);
    }
    translate([20, middle_ball_offset, - .01]) cylinder(d = 45, h = HEIGHT);
  }
}

