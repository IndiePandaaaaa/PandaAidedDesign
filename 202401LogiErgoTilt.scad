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

//intersection() {
//  translate([- WIDTH / 2 + (DEPTH - WIDTH) / 2, DEPTH / 2, 0]) rotate([90, 0, 0]) {
//    linear_extrude(DEPTH) {
//      polygon([
//        [0, 0],
//        [WIDTH, 0],
//        [0, HEIGHT],
//      ]);
//    }
//  }
//  difference() {
//    dia_little = 35;
//    middle_ball_offset = 5;
//    union() {
//      difference() {
//        cylinder(d = DEPTH, h = HEIGHT);
//        translate([-DEPTH, - DEPTH / 2, -1]) cube(DEPTH);
//      }
//
//      translate([0, DEPTH / 2 - dia_little / 2, 0]) cylinder(d = dia_little, h = HEIGHT);
//      translate([0, -DEPTH / 2 + dia_little / 2, 0]) cylinder(d = dia_little, h = HEIGHT);
//      translate([- WIDTH + (DEPTH / 2) + dia_little / 2, middle_ball_offset, 0]) cylinder(d = dia_little, h = HEIGHT);
//      translate([(- WIDTH + (DEPTH / 2) + dia_little / 2) * .5, middle_ball_offset * - 3.25, 0]) cylinder(d = dia_little, h = HEIGHT);
//      translate([(- WIDTH + (DEPTH / 2) + dia_little / 2) * .5, middle_ball_offset * 3.75, 0]) cylinder(d = dia_little, h = HEIGHT);
//    }
//    translate([20, middle_ball_offset, - .01]) cylinder(d = 45, h = HEIGHT);
//  }
//}

mouse_size = [86.5, 120];
hole_od = 12;
hole_depth = 5;

angle = 30;
tilt = 30;

union() {
  width = sin(angle)*mouse_size[1] + cos(angle)*mouse_size[0] - (angle == 30 ? 42 : angle == 60 ? 32 : 0); // fixme: angle why *sad panda noises*
  height = tan(tilt)*width;
  intersection() {
    rotate([0, 0, angle]) translate([-mouse_size[0]/2, -mouse_size[1]/2, 0]) linear_extrude(height) {
      import("./Shapes/LogiErgoM575.svg");
    }
  
    translate([-width/2, mouse_size[1], 0]) rotate([90, 0, 0]) linear_extrude(mouse_size[1]*2) {
      polygon([
        [0, 0],
        [width, 0],
        [0, height],
      ]);
    }
  }

  translate([-width/3, -10, height-9]) rotate([0, tilt, 0]) cylinder(d=hole_od, h=hole_depth + .1);
}
